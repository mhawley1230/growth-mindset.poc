class_name Level
extends Node

@export_category("products")
@export var available_product_icons: Array[Texture2D] = []
@export var seeds_starting: Array[int] = []
@export var plants_starting: Array[int] = []

## Contains product names and Util.PlantType.* enum ref
#@onready var product_names: Array[String]

func _ready() -> void:
	Global.level = self
	
	SignalBus.emit_on_level_ready(self)
	#SignalBus.on_inventory_manager_ready.connect(set_starting_inventory)
	#get_names_from_icon_names()
	

#func get_names_from_icon_names() -> void:
	#for i in available_product_icons:
		## Get name of icon by parsing load path
		#var icon_name: String = Utils.get_name_from_load_path(
				#i.get_load_path())
		#
		#var ref_string: String = "Utils.PlantType." + icon_name.to_upper()
		#product_names.append(icon_name)
		

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
