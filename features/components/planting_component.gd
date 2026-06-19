class_name PlantingComponent
extends Node

## Spawns a plant entity at the cursor position and spends a seed.
## available_plants is the ActionComponent's configured plant scenes (assign in
## player.tscn). plant_type is derived from the scene's root node name.
func create_plant(
		available_plants: Array[PackedScene],
		spawn_position: Vector2,
		inventory: InventoryController,
	) -> void:
	if available_plants.is_empty() or inventory == null:
		return

	var scene: PackedScene = available_plants[0]
	if scene == null:
		return

	var instance: Node2D = scene.instantiate()
	var plant_type: String = instance.name.to_lower()

	if inventory.get_count("seeds", plant_type) <= 0:
		print("not enough %s seeds" % plant_type)
		instance.queue_free()
		return

	instance.name = instance.name + str(instance.get_instance_id())

	var container: Node = owner.get_parent() if owner else get_parent()
	container.add_child(instance)
	instance.global_position = spawn_position

	inventory.remove("seeds", plant_type, 1)
