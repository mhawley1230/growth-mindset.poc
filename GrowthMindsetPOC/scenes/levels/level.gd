class_name Level
extends Node

#region seeds
@export var available_products: Array[Plant] = []
@export var tomato_seeds_starting: int = 2
@export var potato_seeds_starting: int = 1
@export var tomatoes_starting: int = 0
@export var potatoes_starting: int = 0
#endregion

@export var cust_max_order_size: int = 3


func _ready() -> void:
	setup_inventory()


func setup_inventory() -> void:
	var inventory = InventoryManager.new()
	
	inventory.create_inventory("seeds", "tomato", tomato_seeds_starting)
	inventory.create_inventory("seeds", "potato", potato_seeds_starting)
	inventory.create_inventory("plants", "tomato", tomatoes_starting)
	inventory.create_inventory("plants", "potato", potatoes_starting)
