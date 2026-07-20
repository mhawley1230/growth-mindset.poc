class_name CustomerQueue
extends Area2D

# Waiting line for customers approaching TradeArea (see NOTES.txt "DECISION:
# customer behavior"). Lives as a child of a Path2D/PathController and lays
# out max_waiting_points equally-spaced Marker2Ds along the long axis of its
# own CollisionShape2D, so the line matches whatever rectangle was drawn in
# the editor for this queue lane -- no dependency on curve math for placement.
#
# Two independent jobs:
#   1. Gating (every physics frame, after PathController has moved everyone
#      that frame): hold a customer at the waiting point it just reached
#      unless the spot ahead -- the next point in, or the trade area for
#      point 0 -- is open.
#   2. Spawn control (simple occupancy counting via signals): once queue +
#      trade area occupants reach max_waiting_points + 1, the line is full,
#      so PathController's spawn Timer is freed outright; it's recreated the
#      moment an occupant leaves and the count drops.

@export var max_waiting_points: int = 3
@export var trade_area: TradeArea

## index 0 = farthest along the path curve / closest to the trade area.
var waiting_points_array: Array[Marker2D] = []

# Parallel to waiting_points_array: each point's curve offset, derived from
# its final placed position (not the other way around -- see
# _build_waiting_points), used to compare against PathFollow2D.progress.
var _point_offsets: Array[float] = []

var _path: PathController
var _queue_customer_count: int = 0
var _trade_area_customer_count: int = 0

## Customers that have entered TradeArea at least once, keyed by the
## CustomerEntity instance. _is_in_trade_area() only reflects *current*
## overlap, which is indistinguishable between "hasn't reached the trade
## area yet" and "already served and walking off" -- both read as false.
## This set disambiguates the two so _apply_gate never re-gates (and snaps
## backward) a customer who has already been through the trade area.
var _served_customers: Dictionary = {}

func _ready() -> void:
	_path = get_parent() as PathController
	_build_waiting_points()

	if trade_area == null and _path:
		trade_area = _path.get_node_or_null("../TradeArea") as TradeArea

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if trade_area:
		trade_area.customer_entered.connect(_on_trade_area_customer_entered)
		trade_area.trade_area_exited.connect(_on_trade_area_body_exited)
	if _path:
		_path.customer_finished.connect(_on_customer_finished)

	_update_spawn_gate()

func _physics_process(_delta: float) -> void:
	if _path == null or _point_offsets.is_empty():
		return
	for path_follow: PathFollow2D in _path.get_active_path_follows():
		_apply_gate(path_follow)

## Places max_waiting_points Marker2D children along the long axis of this
## queue's own CollisionShape2D rectangle -- index 0 at whichever end sits
## physically closest to the trade area, index max-1 at the opposite end.
## Each marker's curve offset (needed to compare against PathFollow2D.progress
## for gating) is derived from its final position, not used to compute it, so
## a bad offset lookup can no longer throw every marker's placement off.
func _build_waiting_points() -> void:
	for marker: Marker2D in waiting_points_array:
		if is_instance_valid(marker):
			marker.queue_free()
	waiting_points_array.clear()
	_point_offsets.clear()

	if _path == null or _path.curve == null or max_waiting_points <= 0:
		return

	var shape_node: CollisionShape2D = get_node_or_null("CollisionShape2D") as CollisionShape2D
	var rect: RectangleShape2D = (shape_node.shape as RectangleShape2D) if shape_node else null
	if shape_node == null or rect == null:
		return

	var size: Vector2 = rect.size
	var local_center: Vector2 = shape_node.position
	var horizontal: bool = size.x >= size.y
	var extent: float = size.x if horizontal else size.y
	var axis: Vector2 = Vector2.RIGHT if horizontal else Vector2.DOWN
	var half: Vector2 = axis * (extent / 2.0)

	var end_a: Vector2 = local_center + half
	var end_b: Vector2 = local_center - half
	var trade_global: Vector2 = trade_area.global_position if trade_area else to_global(end_a)
	var near_end: Vector2 = end_a if to_global(end_a).distance_to(trade_global) <= to_global(end_b).distance_to(trade_global) else end_b
	var far_end: Vector2 = end_b if near_end == end_a else end_a
	var direction: Vector2 = (far_end - near_end).normalized()
	var spacing: float = extent / float(max_waiting_points)

	var curve: Curve2D = _path.curve
	for i: int in range(max_waiting_points):
		var local_point: Vector2 = near_end + direction * (spacing * i)
		var marker: Marker2D = Marker2D.new()
		marker.name = "WaitingPoint%d" % i
		add_child(marker)
		marker.position = local_point
		waiting_points_array.append(marker)
		_point_offsets.append(curve.get_closest_offset(_path.to_local(to_global(local_point))))

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
	if _is_in_trade_area(customer) or _served_customers.has(customer):
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
## customer having overshot a point slightly by the time this runs, and
## correctly keeps resolving to point 0 once progress is past every point,
## right up until TradeArea takes over.
func _last_passed_gate(progress: float) -> int:
	for i: int in range(_point_offsets.size()):
		if _point_offsets[i] <= progress:
			return i
	return -1

## Whether the spot immediately ahead of waiting point `gate_index` -- the
## next point in, or the trade area itself for point 0 -- is free.
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

## -- Spawn control: plain occupancy counting via signals, independent of the
## gating math above so a bad gate/offset can't also break spawn-stopping. --

func _on_body_entered(body: Node) -> void:
	if body is CustomerEntity:
		_queue_customer_count += 1
		_update_spawn_gate()

func _on_body_exited(body: Node) -> void:
	if body is CustomerEntity:
		_queue_customer_count = max(_queue_customer_count - 1, 0)
		_update_spawn_gate()

func _on_trade_area_customer_entered(customer: Node) -> void:
	_trade_area_customer_count += 1
	if customer is CustomerEntity:
		_served_customers[customer] = true
	_update_spawn_gate()

func _on_trade_area_body_exited(body: Node) -> void:
	if body is CustomerEntity:
		_trade_area_customer_count = max(_trade_area_customer_count - 1, 0)
		_update_spawn_gate()

## Frees the bookkeeping entry once PathController despawns the customer at
## the end of the curve, so _served_customers doesn't hold stale references.
func _on_customer_finished(customer: Node) -> void:
	_served_customers.erase(customer)

## The whole line (every waiting point + the trade area, i.e.
## max_waiting_points + 1 slots) is full: stop spawning outright until an
## occupant leaves and the count drops back below capacity.
func _update_spawn_gate() -> void:
	if _path == null:
		return
	var capacity: int = max_waiting_points + 1
	var occupied: int = _queue_customer_count + _trade_area_customer_count
	_path.set_spawn_paused(occupied >= capacity)

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
	for child: Node in path_follow.get_children():
		if child is CustomerEntity:
			return child
	return null
