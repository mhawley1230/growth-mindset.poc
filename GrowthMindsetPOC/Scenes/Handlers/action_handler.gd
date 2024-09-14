class_name ActionHandler
extends Node

@export var available_plants: Array[PackedScene] = []


func detect_overlapped_areas(target_area: Area2D) -> Array[Area2D]:
	return target_area.get_overlapping_areas()


func is_planting_enabled(areas: Array[Area2D]) -> bool:
	var enabled: bool = false
	
	for area in areas:
		if area is FarmPlot and areas.size() == 1:
			enabled = true
		
	return enabled


func create_plant(index: int, spawn_position: Vector2) -> void:
	var new_plant = available_plants[index].instantiate()
	var plant_container = NodeExtensions.get_plant_container()
	
	if plant_container == null:
		return
	else:
		plant_container.add_child(new_plant)
		new_plant.num_created += 1
		new_plant.position = Vector2i(spawn_position)

func harvest_plant(areas: Array[Area2D]) -> void:
	for area in areas:
		if area is PlantEntity && area.isHarvestable:
			print(area.plant_name)
			SignalBus.emit_on_plant_collected(area.plant_name)
			area.free()
