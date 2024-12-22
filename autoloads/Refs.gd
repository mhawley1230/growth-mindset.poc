extends Node

@export_group("Icons")
@export var tomato_icon: Texture2D
@export var potato_icon: Texture2D

@export var tomato_seed_icon: Texture2D
@export var potato_seed_icon: Texture2D

@export_group("Packed Scenes")
@export var player_scene: PackedScene
@export var cursor_scene: PackedScene
@export var tomato_scene: PackedScene
@export var potato_scene: PackedScene
@export var frog_scene: PackedScene

@onready var plant_scenes: Dictionary = {
	Plant.Type.TOMATO: tomato_scene,
	Plant.Type.POTATO: potato_scene,
}

@onready var plant_icons: Dictionary = {
	Plant.Type.TOMATO: tomato_icon,
	Plant.Type.POTATO: potato_icon,
}

@onready var seed_icons: Dictionary = {
	Plant.Type.TOMATO: tomato_seed_icon,
	Plant.Type.POTATO: potato_seed_icon,
}


func get_plant_scene_by_type(type: Plant.Type) -> PackedScene:
	return plant_scenes[type]


func get_plant_icon_by_type(type: Plant.Type) -> Texture2D:
	return plant_icons[type]


func get_plant_seed_icon_by_type(type: Plant.Type) -> Texture2D:
	return seed_icons[type]

#func get_customer_scene_by_type(type: Customer.Type):
	#return customer_dict[type] 
