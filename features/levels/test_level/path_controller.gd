class_name PathController
extends Path2D

# Level-owned movement + spawn-timing authority for customers walking this
# path (see NOTES.txt "DECISION: customer behavior"). PathController does NOT
# decide *which* customer spawns -- that's EntitySpawnController's job, driven
# by its customers_array. PathController only owns:
#   * the spawn Timer (random interval, restarts itself every time it fires)
#   * the PathFollow2D/MovementComponent template, duplicated per customer so
#     multiple customers can walk this same path/curve at once
#   * moving every active customer along the curve each physics frame

## Fired when the spawn Timer completes. EntitySpawnController listens for
## this, instantiates a customer from customers_array, and calls
## add_customer() with the result.
signal spawn_ready

## Emitted when a customer reaches the end of the path (so the level can
## recycle / count it) instead of the path freeing itself blindly.
signal customer_finished(customer: Node)

## Template PathFollow2D (with its own child MovementComponent) kept in the
## scene as a blueprint -- duplicated for every new customer instead of being
## walked itself. Hidden/paused in _ready() so it never visibly participates.
@export var path_follow_template: PathFollow2D
@export var trade_area: TradeArea

## Random spawn interval range, per plan: "a random float between 1.0 seconds
## and 5.0 seconds, then restarts with a new value".
@export var min_spawn_interval: float = 1.0
@export var max_spawn_interval: float = 5.0

## Most recently rolled interval; exported so it's visible/inspectable, not
## meant to be hand-edited (the timer re-rolls it every cycle).
@export var spawn_interval: float = 0.0

var _timer: Timer
var _active_path_follows: Array[PathFollow2D] = []

func _ready() -> void:
	if path_follow_template:
		path_follow_template.visible = false
		path_follow_template.set_physics_process(false)

	if trade_area:
		trade_area.customer_entered.connect(_on_trade_area_customer_entered)
		trade_area.trade_area_exited.connect(_on_trade_area_exited)

	_start_spawn_timer()

## Starts the spawn Timer (creating it the first time) with a freshly rolled
## random interval; called again from _on_spawn_timer_timeout so the timer
## keeps restarting with a new value forever.
func _start_spawn_timer() -> void:
	if _timer == null:
		_timer = Timer.new()
		_timer.one_shot = true
		add_child(_timer)
		_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_interval = randf_range(min_spawn_interval, max_spawn_interval)
	_timer.start(spawn_interval)

func _on_spawn_timer_timeout() -> void:
	spawn_ready.emit()
	_start_spawn_timer()

## Lets CustomerQueue pause/resume spawning once the whole line (every
## waiting point + the trade area) is full, without CustomerQueue needing to
## know anything about Timer internals.
func set_spawn_paused(paused: bool) -> void:
	if _timer:
		_timer.paused = paused

## Called by EntitySpawnController once it has instantiated a customer from
## customers_array. Duplicates the template PathFollow2D (and its
## MovementComponent), parents the customer under the duplicate, and starts
## tracking it so _physics_process moves it along the curve.
func add_customer(customer: CharacterBody2D) -> void:
	if path_follow_template == null or customer == null:
		return

	var path_follow: PathFollow2D = path_follow_template.duplicate()
	path_follow.visible = true
	path_follow.set_physics_process(true)
	add_child(path_follow)
	path_follow.progress = 0.0
	path_follow.add_child(customer)
	customer.global_position = path_follow.global_position
	_active_path_follows.append(path_follow)

func _physics_process(delta: float) -> void:
	# Iterate a copy since _advance_customer may remove entries mid-loop.
	for path_follow: PathFollow2D in _active_path_follows.duplicate():
		_advance_customer(path_follow, delta)

func _advance_customer(path_follow: PathFollow2D, delta: float) -> void:
	var customer: CharacterBody2D = _get_customer(path_follow)
	var movement_component: MovementComponent = path_follow.get_node_or_null("MovementComponent")
	if customer == null or movement_component == null:
		return

	path_follow.progress += movement_component.movement_speed * delta

	if path_follow.progress_ratio > 0.5:
		var sprite: Sprite2D = customer.get_node_or_null("Sprite2D")
		if sprite:
			sprite.flip_h = true

	if path_follow.progress_ratio >= 1.0:
		_active_path_follows.erase(path_follow)
		customer_finished.emit(customer)
		path_follow.queue_free()

func _get_customer(path_follow: PathFollow2D) -> CharacterBody2D:
	for child: Node in path_follow.get_children():
		if child is CharacterBody2D:
			return child
	return null

## Lets CustomerQueue (a sibling-scoped child of this Path2D) see every
## customer currently walking the curve, so it can gate them at its waiting
## points without duplicating PathController's own movement bookkeeping.
func get_active_path_follows() -> Array[PathFollow2D]:
	return _active_path_follows.duplicate()

## Connect to TradeArea.customer_entered so that specific customer stops
## while trading -- other customers still walking the path are unaffected.
func _on_trade_area_customer_entered(customer: Node) -> void:
	var movement_component: MovementComponent = _movement_component_for(customer)
	if movement_component:
		movement_component.movement_speed = 0

## The customer is stopped (speed 0) while waiting, so it can only leave the
## TradeArea under its own power once it starts moving again -- guard this to
## the customer itself so the player stepping out mid-trade doesn't
## prematurely release a customer that hasn't been served yet.
func _on_trade_area_exited(body: Node) -> void:
	if body is CustomerEntity:
		resume_customer(body)

## Called (via LevelContext) once TradingComponent confirms a trade cleared
## this specific customer's order: resumes movement at the template's speed.
func resume_customer(customer: Node) -> void:
	var movement_component: MovementComponent = _movement_component_for(customer)
	var template_component: MovementComponent = path_follow_template.get_node_or_null("MovementComponent") if path_follow_template else null
	if movement_component and template_component:
		movement_component.movement_speed = template_component.movement_speed

func _movement_component_for(customer: Node) -> MovementComponent:
	var parent: Node = customer.get_parent() if customer else null
	if parent is PathFollow2D:
		return parent.get_node_or_null("MovementComponent")
	return null
