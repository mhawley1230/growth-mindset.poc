class_name LevelContext
extends Node

var _game_controller: GameController
var _game_state_holder: GameStateHolder

#@export_category("products")
#@export var available_product_icons: Array[Texture2D] = []
#@export var seeds_starting: Array[int] = []
#@export var plants_starting: Array[int] = []

#var _game_controller: GameController
#var _game_state_holder: GameStateHolder

## Contains product names and Util.PlantType.* enum ref
#@onready var inventory_manager: InventoryManager = Global.inventory_manager
#@onready var product_names: Array[String]


#func initialize(entity_spawn_controller: EntitySpawnController) -> void:
	#entity_spawn_controller.instantiate_player()
	
#
#
#func _ready() -> void:
	#inventory_manager.clear_inventory()
	#get_names_from_icon_names()
	#set_starting_inventory()


#func get_names_from_icon_names() -> void:
	#for icon: Texture2D in available_product_icons:
		## Get name of icon by parsing load path
		#var icon_name: String = Utils.get_name_from_load_path(
				#icon.resource_path)
		#
		##var ref_string: String = "Utils.PlantType." + icon_name.to_upper()
		#product_names.append(icon_name)


#func set_starting_inventory() -> void:
	#for i: int in product_names.size():
		#inventory_manager.add_inventory("seeds", product_names[i],
				#seeds_starting[i])
		#inventory_manager.add_inventory("plants", product_names[i],
				#plants_starting[i])
