class_name ActionHandler
extends Node

@export var available_plants: Array[PackedScene] = []


func create_plant(index: int, spawn_position: Vector2) -> void:
	var new_plant: Sprite2D = available_plants[index].instantiate()
	
	var plant_container = NodeExtensions.get_plant_container()
	plant_container.add_child(new_plant)
	new_plant.position = spawn_position
