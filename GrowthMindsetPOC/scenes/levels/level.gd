extends Node

#region seeds
@export var available_products: Array[Plant] = []
@export var tomato_seeds_starting: int = 2
@export var potato_seeds_starting: int = 1
@export var tomatoes_starting: int = 0
@export var potatoes_starting: int = 0

@export var cust_max_order_size: int = 3


func _ready() -> void:
	Inventory.create_inventory("seeds", "tomato", tomato_seeds_starting)
	Inventory.create_inventory("seeds", "potato", potato_seeds_starting)
	Inventory.create_inventory("plants", "tomato", tomatoes_starting)
	Inventory.create_inventory("plants", "potato", potatoes_starting)
