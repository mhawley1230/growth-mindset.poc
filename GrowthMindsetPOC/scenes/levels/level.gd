class_name Level
extends Node

@export_category("products")
@export var tomato_seeds_starting: int = 2
@export var potato_seeds_starting: int = 1
@export var tomatoes_starting: int = 1
@export var potatoes_starting: int = 1

#@export var available_products: Array[PackedScene] = []

@onready var available_products: Array[PackedScene]

func _ready() -> void:
	Global.level = self
	
	SignalBus.emit_on_level_ready(self)
	SignalBus.on_inventory_manager_ready.connect(set_starting_inventory)
	
	available_products.append(
			Refs.get_plant_scene_by_type(Utils.PlantType.POTATO))
	available_products.append(
			Refs.get_plant_scene_by_type(Utils.PlantType.TOMATO))
	


func set_starting_inventory(inventory: InventoryManager) -> void:
	inventory.clear_inventory()
	
	inventory.add_inventory("seeds", "tomato", tomato_seeds_starting)
	inventory.add_inventory("seeds", "potato", potato_seeds_starting)
	inventory.add_inventory("plants", "tomato", tomatoes_starting)
	inventory.add_inventory("plants", "potato", potatoes_starting)
	
	print(inventory.get_all_inventory())
