class_name Path
extends Path2D

@export var customer: PackedScene
@export var movement_component: Node = null
@onready var path_follow: PathFollow2D = $PathFollow2D

# Emitted when the customer reaches the end of the path (so the level can
# recycle / count it) instead of the path freeing itself blindly.
signal customer_finished(customer: Node)

var instance: CharacterBody2D

func _ready() -> void:
	if customer == null:
		return
	instance = customer.instantiate()
	path_follow.add_child(instance)
	instance.global_position = path_follow.global_position

func _physics_process(delta: float) -> void:
	if instance == null or movement_component == null:
		return

	path_follow.set_progress(path_follow.get_progress() + movement_component.movement_speed * delta)

	if path_follow.get_progress_ratio() > 0.5:
		var sprite: Node = instance.get_node_or_null("Sprite2D")
		if sprite:
			sprite.flip_h = true

	if path_follow.get_progress_ratio() >= 1.0:
		customer_finished.emit(instance)
		queue_free()

## Connect to TradeArea.customer_entered so the customer stops while trading.
func on_trade_area_entered(_customer: Node) -> void:
	if movement_component:
		movement_component.movement_speed = 0

func on_trade_area_exited(_body: Node) -> void:
	if movement_component:
		movement_component.movement_speed = 300
