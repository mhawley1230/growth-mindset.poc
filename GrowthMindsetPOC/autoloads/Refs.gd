extends Node

@export_group("Player Scene")
@export var player_scene: PackedScene
@export var cursor_scene: PackedScene

@export_group("Plant Scenes")
@export var tomato_scene: PackedScene
@export var potato_scene: PackedScene

@export_group("Customer scene")
@export var frog_scene: PackedScene

var plant_dict: Dictionary = {
	Plant.Type.TOMATO: tomato_scene,
	Plant.Type.POTATO: potato_scene
}

#var customer_dict: Dictionary = {
	#Customer.Type.FROG: frog_scene
#}


func get_plant_scene_by_type(type: Plant.Type) -> PackedScene:
	return plant_dict[type]


#func get_customer_scene_by_type(type: Customer.Type):
	#return customer_dict[type] 
