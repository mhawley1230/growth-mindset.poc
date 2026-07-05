class_name LevelOverlay
extends Node

@export var seeds_box: SeedsBox
@export var plants_box: PlantsBox

func initialize(inventory_controller: InventoryController) -> void:
		seeds_box.initialize(inventory_controller)
		plants_box.initialize(inventory_controller)
		print("Overlay initialized")
