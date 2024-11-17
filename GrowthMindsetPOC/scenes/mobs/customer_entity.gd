class_name CustomerEntity
extends Node2D


@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
@onready var movement_handler: MovementHandler = $HandlerContainer/MovementHandler
@onready var customer_sprite: Sprite2D = $Path2D/PathFollow2D/CharacterBody2D/Sprite2D
@onready var customer_order_handler: CustomerOrderHandler = $HandlerContainer/CustomerOrderHandler

func _ready() -> void:
	SignalBus.on_customer_wait_area_entered.connect(on_customer_wait_area_entered)
	customer_order_handler.add_order(customer_order_handler.create_order())


func _physics_process(delta: float) -> void:
	path_follow.set_progress(path_follow.get_progress() + movement_handler.movement_speed * delta)
	
	if path_follow.get_progress_ratio() > 0.5:
		flip()
	
	if path_follow.get_progress_ratio() >= 1.0:
		despawn_customer()


func flip():
	customer_sprite.flip_h = true


func despawn_customer():
	SignalBus.emit_on_customer_despawn(self)
	queue_free()


func on_customer_wait_area_entered():
	movement_handler.movement_speed = 0
	await SignalBus.on_trade_complete
	movement_handler.movement_speed = 300
