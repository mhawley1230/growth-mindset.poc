class_name PlantingComponent
extends Node

@export var level: Level = null
@export var inventory_manager: Node = null


func create_plant(index: int, spawn_position: Vector2) -> void:	
	var entity_container: Node = NodeExtensions.get_entity_container()
	
	if entity_container == null:
		return
	
	var new_plant: Node2D = level.available_products[index].instantiate()
	var plant_instance: String = new_plant.name + "_" + str(new_plant.get_instance_id())
	new_plant.name = plant_instance
	var plant_type = Globals.strip_instance_id(plant_instance)
	
	
	#if inventory_manager.get_inventory("seeds", plant_type) < 1:
		#print("not enough seeds")
		#return
	
	entity_container.add_child(new_plant)
	new_plant.position = Vector2i(spawn_position)
	#inventory_manager.remove_inventory("seeds", plant_type, 1)
