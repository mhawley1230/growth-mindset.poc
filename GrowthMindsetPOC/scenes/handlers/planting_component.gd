class_name PlantingComponent
extends Node
 

func create_plant(index: int, spawn_position: Vector2) -> void:	
	var inv: InventoryManager = Global.inventory_manager
	var entity_container: Node = NodeExtensions.get_entity_container()
	
	if entity_container == null:
		return
	
	var instance: Plant = Global.level.available_products[index].instantiate()
	var plant_type = instance.name.to_lower()
	instance.name = instance.name + str(instance.get_instance_id())
	
	var current_inv = inv.get_inventory("seeds", plant_type)
	if current_inv[plant_type] < 1:
		print("not enough seeds")
		return
	
	entity_container.add_child(instance)
	instance.position = Vector2i(spawn_position)
	inv.remove_inventory("seeds", plant_type, 1)
	#SignalBus.on_seed_inventory_updated.emit(
			#plant_type,
			#current_inv,
			#inv.get_inventory("seeds", plant_type)[plant_type]
		#)
