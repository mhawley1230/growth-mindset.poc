extends Node

@export_group("Icons")
@export var tomato_icon: Texture2D
@export var potato_icon: Texture2D

@export_group("Packed Scenes")
@export var player_scene: PackedScene
@export var cursor_scene: PackedScene
@export var tomato_scene: PackedScene
@export var potato_scene: PackedScene
@export var frog_scene: PackedScene

@onready var plant_scenes: Dictionary = {
	Utils.PlantType.TOMATO: tomato_scene,
	Utils.PlantType.POTATO: potato_scene,
}

@onready var plant_icons: Dictionary = {
	Utils.PlantType.TOMATO: tomato_icon,
	Utils.PlantType.POTATO: potato_icon,
}


func get_plant_scene_by_type(type: Utils.PlantType) -> PackedScene:
	return plant_scenes[type]


func get_plant_icon_by_type(type: Utils.PlantType) -> Texture2D:
	return plant_icons[type]


#func get_customer_scene_by_type(type: Customer.Type):
	#return customer_dict[type] 
