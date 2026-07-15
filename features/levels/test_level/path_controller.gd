class_name PathController
extends Path2D

@export var customer_scene: PackedScene
@export var path_follow: PathFollow2D
@export var movement_component: MovementComponent
@export var trade_area: TradeArea

var customer: CharacterBody2D

# Emitted when the customer reaches the end of the path (so the level can
# recycle / count it) instead of the path freeing itself blindly.
signal customer_finished(customer: Area2D)

var instance: CharacterBody2D

func _ready() -> void:
	if movement_component == null:
		movement_component = MovementComponent.new()

	if customer_scene == null:
		return
	
	customer = customer_scene.instantiate()
	path_follow.add_child(customer)
	customer.global_position = path_follow.global_position
	
	if trade_area:
		trade_area.customer_entered.connect(on_trade_area_entered)
		trade_area.trade_area_exited.connect(on_trade_area_exited)

func _physics_process(delta: float) -> void:
	if customer == null or movement_component == null:
		return

	path_follow.set_progress(path_follow.get_progress() + movement_component.movement_speed * delta)
	
	if path_follow.get_progress_ratio() > 0.5:
		var sprite: Sprite2D = customer.get_node_or_null("Sprite2D")
		if sprite:
			sprite.flip_h = true

	if path_follow.get_progress_ratio() >= 1.0:
		customer_finished.emit(instance)
		queue_free()

## Connect to TradeArea.customer_entered so the customer stops while trading.
func on_trade_area_entered(_customer: Node) -> void:
	if movement_component:
		movement_component.movement_speed = 0

## The customer is stopped (speed 0) while waiting, so it can only leave the
## TradeArea under its own power once it starts moving again -- guard this to
## the customer itself so the player stepping out mid-trade doesn't
## prematurely release a customer that hasn't been served yet.
func on_trade_area_exited(body: Node) -> void:
	if body is CustomerEntity and movement_component:
		movement_component.movement_speed = 300

## Connected to TradingComponent.trade_completed by LevelContext: once a trade
## clears the waiting customer's order, let it resume moving along the path.
func on_trade_completed() -> void:
	if movement_component:
		movement_component.movement_speed = 300
