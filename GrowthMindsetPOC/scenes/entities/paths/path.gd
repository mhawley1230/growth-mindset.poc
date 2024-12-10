class_name Path
extends Path2D

@export var customer: PackedScene
@export var movement_component: Node = null
@onready var path_follow: PathFollow2D = $PathFollow2D
@onready var instance: CharacterBody2D


func _ready():
	SignalBus.on_customer_trade_area_entered.connect(on_customer_trade_area_entered)
	
	instance = customer.instantiate()
	path_follow.add_child(instance)
	instance.global_position = path_follow.global_position

func _physics_process(delta):
	path_follow.set_progress(path_follow.get_progress() + movement_component.movement_speed * delta)
	
	if path_follow.get_progress_ratio() > 0.5:
		instance.get_node("Sprite2D").flip_h = true
	
	if path_follow.get_progress_ratio() >= 1.0:
		queue_free()

func on_customer_trade_area_entered(_body, _area):
	movement_component.movement_speed = 0
	await SignalBus.on_trade_complete
	movement_component.movement_speed = 300
