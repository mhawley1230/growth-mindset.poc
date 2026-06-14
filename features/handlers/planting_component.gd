class_name PlantingComponent
extends Node
#
#@onready var inv: InventoryManager = Global.inventory_manager
#
#func create_plant(index: int, spawn_position: Vector2) -> void:	
	#var entity_container: Node = NodeExtensions.get_entity_container()
	#
	#if entity_container == null:
		#return
	#
	#var icons: Array[Texture2D] = Global.level.available_product_icons
	##var key: int = Refs.plant_icons.find_key(icons[index])
	##var scene: PackedScene = Refs.get_plant_scene_by_type(key)
	##var instance: Plant = scene.instantiate()
	#var plant_type: String = instance.name.to_lower()
	#instance.name = instance.name + str(instance.get_instance_id())
	#
	#var current_inv: Dictionary = inv.get_inventory("seeds", plant_type)
	#if current_inv[plant_type] <= 0:
		#print("not enough %s seeds" % plant_type)
		#return
	#
	#entity_container.add_child(instance)
	#instance.position = Vector2i(spawn_position)
	#inv.remove_inventory("seeds", plant_type, 1)
