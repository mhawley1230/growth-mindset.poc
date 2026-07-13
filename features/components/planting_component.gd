class_name PlantingComponent
extends Node

## Spawns a plant entity at the cursor position and spends a seed.
## plant_data is the player's currently selected crop (Player.get_selected_plant,
## cycled by the swap_plant input). The inventory key comes from
## plant_data.plant_name rather than the scene's root node name, so it stays
## correct regardless of how a given plant scene names its root.
func create_plant(
		plant_data: PlantData,
		spawn_position: Vector2,
		inventory: InventoryController,
	) -> void:
	if plant_data == null or plant_data.scene == null or inventory == null:
		return

	var plant_type: String = plant_data.plant_name

	if inventory.get_count("seeds", plant_type) <= 0:
		print("not enough %s seeds" % plant_type)
		return
	
	var instance: Node2D = plant_data.scene.instantiate()
	instance.name = instance.name + str(instance.get_instance_id())

	var container: Node = owner.get_parent() if owner else get_parent()
	container.add_child(instance)
	instance.global_position = spawn_position

	inventory.remove("seeds", plant_type, 1)
