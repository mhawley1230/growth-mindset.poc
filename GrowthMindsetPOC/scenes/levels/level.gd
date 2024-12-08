class_name Level
extends Node

#region inventory
@onready var manager_container = NodeExtensions.get_manager_container()
@onready var inventory_manager: InventoryManager = null
#endregion

#region product
@export var available_products: Array[Plant] = []
@export var tomato_seeds_starting: int = 2
@export var potato_seeds_starting: int = 1
@export var tomatoes_starting: int = 0
@export var potatoes_starting: int = 0
@export var cust_max_order_size: int = 3
#endregion


func _ready() -> void:
	if manager_container == null: 
		return
	
	inventory_manager = manager_container.get_node("InventoryManager")
	setup_inventory()


func setup_inventory() -> void:
	inventory_manager.clear_inventory()
	
	inventory_manager.create_inventory("seeds", "tomato", tomato_seeds_starting)
	inventory_manager.create_inventory("seeds", "potato", potato_seeds_starting)
	inventory_manager.create_inventory("plants", "tomato", tomatoes_starting)
	inventory_manager.create_inventory("plants", "potato", potatoes_starting)
