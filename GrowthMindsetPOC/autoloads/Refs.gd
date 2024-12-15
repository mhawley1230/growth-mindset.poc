extends Node

@export_group("Player Scene")
@export var player_scene: PackedScene
@export var cursor_scene: PackedScene

@export_group("Plant Scenes")
@export var tomato_scene: PackedScene
@export var potato_scene: PackedScene

@export_group("Customer scene")
@export var frog_scene: PackedScene

@onready var plants: Dictionary = {
	Utils.PlantType.TOMATO: tomato_scene,
	Utils.PlantType.POTATO: potato_scene,
}

func get_plant_scene_by_type(type: Utils.PlantType) -> PackedScene:
	return plants[type]


#func get_customer_scene_by_type(type: Customer.Type):
	#return customer_dict[type] 
