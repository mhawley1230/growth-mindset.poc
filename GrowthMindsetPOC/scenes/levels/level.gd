class_name Level
extends Node

#region product
@export_category("products")
@export var available_products: Array[Plant] = []
@export var tomato_seeds_starting: int = 2
@export var potato_seeds_starting: int = 1
@export var tomatoes_starting: int = 0
@export var potatoes_starting: int = 0
#endregion

#region inventory
@onready var manager_container: Node = NodeExtensions.get_manager_container()
@onready var inventory_manager := $InventoryManagerComponent
#endregion


func _ready() -> void:
	SignalBus.emit_on_level_ready(self)
	
	if manager_container == null: 
		return
	
	inventory_manager = manager_container.get_node("InventoryManager")
	
	setup_starting_inventory()


func setup_starting_inventory() -> void:
	inventory_manager.clear_inventory()
	
	inventory_manager.create_inventory("seeds", "tomato", tomato_seeds_starting)
	inventory_manager.create_inventory("seeds", "potato", potato_seeds_starting)
	inventory_manager.create_inventory("plants", "tomato", tomatoes_starting)
	inventory_manager.create_inventory("plants", "potato", potatoes_starting)
