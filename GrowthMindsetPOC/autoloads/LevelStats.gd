extends Node

@onready var inventory: Dictionary = {}
@export var tomatoes_in_inventory: int = 0
@export var tomato_seeds_in_inventory: int = 0

func _ready() -> void:
	SignalBus.on_product_collected.connect(on_product_collected)
	SignalBus.on_trade_complete.connect(on_trade_complete)


func on_product_collected(plant_name) -> void:
	if inventory == null:
		return
	
	match plant_name.to_lower:
		"tomato":
			tomatoes_in_inventory += 1
			print("tomatoes in inventory: ", tomatoes_in_inventory)


func on_trade_complete() -> void:
	#if tomato_seeds_in_inventory >= 1:
		#tomato_seeds_in_inventory -= 1
	pass
