class_name Level
extends Node

@export_category("products")
@export var level_product_icons: Array[Texture2D] = []
@export var seeds_starting: Array[int] = []
@export var plants_starting: Array[int] = []

@onready var available_products: Array[String]

func _ready() -> void:
	Global.level = self
	
	SignalBus.emit_on_level_ready(self)
	#SignalBus.on_inventory_manager_ready.connect(set_starting_inventory)
	
	for i in level_product_icons:
		available_products.append(
				Utils.get_name_from_load_path(i.get_load_path().to_upper()))
	
	print(available_products)
	
	#available_products.append(
			#Refs.get_plant_icon_by_type(Utils.PlantType.POTATO))
	#available_products.append(
			#Refs.get_plant_icon_by_type(Utils.PlantType.TOMATO))
	
	#for i in available_products:
		

#func set_starting_inventory(inventory: InventoryManager) -> void:
	#inventory.clear_inventory()
	#
	#for i in available_products:
		#Global.inventory_manager.add_inventory("seeds", available_products[i],
				#seeds_starting[i])
	#inventory.add_inventory(
			#"seeds", "tomato", tomato_seeds_starting)
	#inventory.add_inventory(
			#"seeds", "potato", potato_seeds_starting)
	#inventory.add_inventory(
			#"plants", "tomato", tomatoes_starting)
	#inventory.add_inventory(
			#"plants", "potato", potatoes_starting)
