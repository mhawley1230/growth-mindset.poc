class_name CustomerQueue
extends Area2D

# Waiting line for customers approaching TradeArea (see NOTES.txt "DECISION:
# customer behavior"). Lives as a child of a Path2D/PathController and lays
# out max_waiting_points equally-spaced Marker2Ds along that same curve, so
# the line visually follows the path customers already walk.
#
# Every physics frame (which, since this node is a child of the Path2D,
# always runs after PathController has already advanced everyone's progress
# for that frame) this script:
#   * holds a customer at the first waiting point it reaches whose next spot
#     -- the point ahead, or the trade area for point 0 -- is occupied
#   * lets it go the instant that next spot opens up, which naturally cascades
#     the whole line forward one spot at a time as each one clears
#   * pauses PathController's spawn timer while every point AND the trade
#     area are full, and lets it resume once the trade area customer leaves

@export var max_waiting_points: int = 3
@export var point_spacing: float = 128.0
@export var trade_area: TradeArea

## index 0 = farthest along the path curve / closest to the trade area.
var waiting_points_array: Array[Marker2D] = []

# Parallel to waiting_points_array: the curve offset (Curve2D.sample_baked
# input) each point sits at.
var _point_offsets: Array[float] = []

var _path: Path2D

func _ready() -> void:
	_path = get_parent() as Path2D
	_build_waiting_points()
	if trade_area == null and _path:
		trade_area = _path.get_node_or_null("../TradeArea") as TradeArea

func _physics_process(_delta: float) -> void:
	if _path == null or _point_offsets.is_empty():
		return

	for path_follow: PathFollow2D in _path.get_active_path_follows():
		_apply_gate(path_follow)

	_path.set_spawn_paused(_is_full())

## (Re)builds waiting_points_array: max_waiting_points Marker2D children,
## evenly spaced point_spacing apart, walking backwards along the path curve
## from wherever this queue's own collision shape sits (falls back to the
## queue node's position if it has no CollisionShape2D child).
func _build_waiting_points() -> void:
	for marker in waiting_points_array:
		if is_instance_valid(marker):
			marker.queue_free()
	waiting_points_array.clear()
	_point_offsets.clear()

	if _path == null or _path.curve == null or max_waiting_points <= 0:
		return

	var curve: Curve2D = _path.curve
	var shape_node: Node2D = get_node_or_null("CollisionShape2D") as Node2D
	var anchor_global: Vector2 = shape_node.global_position if shape_node else global_position
	var base_offset: float = curve.get_closest_offset(_path.to_local(anchor_global))

	for i:int in range(max_waiting_points):
		var offset: float = max(base_offset - i * point_spacing, 0.0)
		var marker: Marker2D = Marker2D.new()
		marker.name = "WaitingPoint%d" % i
		add_child(marker)
		marker.position = to_local(_path.to_global(curve.sample_baked(offset)))
		waiting_points_array.append(marker)
		_point_offsets.append(offset)

## Holds `path_follow`'s customer at the waiting point it has just reached
## (or overshot slightly, since this runs after movement) unless the spot
## ahead of that point is open, in which case it's free to keep moving.
func _apply_gate(path_follow: PathFollow2D) -> void:
	var customer: CustomerEntity = _get_customer(path_follow)
	var movement_component: MovementComponent = path_follow.get_node_or_null("MovementComponent")
	if customer == null or movement_component == null:
		return

	# Once a customer has actually entered TradeArea (or already been served
	# and is walking off), the queue no longer has any say over their speed --
	# that's PathController's trade-area enter/exit handlers from here.
	if _is_in_trade_area(customer):
		return

	var gate_index: int = _last_passed_gate(path_follow.progress)
	if gate_index == -1:
		return # hasn't reached the back of the line yet -- keep walking freely

	if _slot_ahead_free(gate_index, path_follow):
		movement_component.movement_speed = _template_speed()
	else:
		movement_component.movement_speed = 0
		path_follow.progress = _point_offsets[gate_index]

## Largest waiting-point offset at or before `progress` -- robust to a
## customer having overshot a point slightly by the time this runs (unlike
## looking for an exact match), and correctly keeps resolving to point 0 once
## progress is past every point, right up until TradeArea takes over.
func _last_passed_gate(progress: float) -> int:
	for i in range(_point_offsets.size()):
		if _point_offsets[i] <= progress:
			return i
	return -1

## Whether the spot immediately ahead of waiting point `gate_index` -- the
## next point in, or the trade area itself for point 0 -- is free.
## `excluding` is the customer's own PathFollow2D, so a customer never counts
## its own (about-to-be-vacated) point against itself.
func _slot_ahead_free(gate_index: int, excluding: PathFollow2D) -> bool:
	if gate_index == 0:
		return not _trade_area_has_customer()
	return not _point_occupied(gate_index - 1, excluding)

## True if some *other* customer is currently parked (stopped, not just
## passing through) at waiting point `index`.
func _point_occupied(index: int, excluding: PathFollow2D) -> bool:
	for path_follow: PathFollow2D in _path.get_active_path_follows():
		if path_follow == excluding:
			continue
		var customer: CustomerEntity = _get_customer(path_follow)
		if customer == null or _is_in_trade_area(customer):
			continue
		var movement_component: MovementComponent = path_follow.get_node_or_null("MovementComponent")
		if movement_component == null or movement_component.movement_speed != 0:
			continue
		if _last_passed_gate(path_follow.progress) == index:
			return true
	return false

## Every waiting point has someone parked at it AND the trade area has a
## customer -- the whole line is full front to back.
func _is_full() -> bool:
	if _point_offsets.is_empty() or not _trade_area_has_customer():
		return false
	for i in range(_point_offsets.size()):
		if not _point_occupied(i, null):
			return false
	return true

func _trade_area_has_customer() -> bool:
	if trade_area == null:
		return false
	for occupant: Node in trade_area.get_overlapping_bodies():
		if occupant is CustomerEntity:
			return true
	return false

func _is_in_trade_area(customer: CustomerEntity) -> bool:
	if trade_area == null:
		return false
	return trade_area.get_overlapping_bodies().has(customer)

func _template_speed() -> int:
	if _path and _path.path_follow_template:
		var template_component: MovementComponent = _path.path_follow_template.get_node_or_null("MovementComponent")
		if template_component:
			return template_component.movement_speed
	return 0

func _get_customer(path_follow: PathFollow2D) -> CustomerEntity:
	for child in path_follow.get_children():
		if child is CustomerEntity:
			return child
	return null
