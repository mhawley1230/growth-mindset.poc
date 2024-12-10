class_name HarvestingComponent
extends Node

@export var body: CharacterBody2D = null
@export var cursor: Area2D = null
@export var target_plant: Area2D = null
@export var inventory_manager: Node = null

func harvest_plant(areas: Array[Area2D]) -> void:
	for area in areas:
		if area.is_in_group("plant"):
			var plant_type = Globals.strip_instance_id(area.name)
			inventory_manager.add_inventory("plants", plant_type, 1)
			area.free()
