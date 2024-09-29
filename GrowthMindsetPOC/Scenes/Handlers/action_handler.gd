class_name ActionHandler
extends Node

@export var available_plants: Array[PackedScene] = []


func detect_overlapped_areas(target: Area2D) -> Array[Area2D]:
	return target.get_overlapping_areas()


func is_planting_enabled(areas: Array[Area2D]) -> bool:
	var enabled: bool = false
	
	for area in areas:
		if area is FarmPlot and areas.size() == 1:
			enabled = true
		
	return enabled


func create_plant(index: int, spawn_position: Vector2) -> void:
	var new_plant = available_plants[index].instantiate()
	var entity_container = NodeExtensions.get_entity_container()
	
	if entity_container == null:
		return
		
	entity_container.add_child(new_plant)
	new_plant.num_created += 1
	new_plant.position = Vector2i(spawn_position)


func harvest_plant(areas: Array[Area2D]) -> void:
	for area in areas:
		if area is PlantEntity && area.isHarvestable:
			SignalBus.emit_on_product_collected(area.plant_name)
			GlobalStatsContainer.tomato_plants_collected += 1
			area.free()

## TODO: Figure out way to swap types of seeds in action bar
##     - What button should this be on?
##     - How are seed types stored in action bar?
##     - What variables are accessed? 
##     - What data structure works best?
## func swap_seed_type() -> void:
##     1. Access seeds data object
##     2. Increment index/key of array, list, ect.
##     3. Update action bar visuals

## TODO: Refactor: 
##    1. Create trade area for player
##    2. Trade area is child of farm stand
##    3. Enable trading when: CustomerEntity is in CustomerWaitArea, 
##         player is in PlayerTradeArea
##    4. Transact, update global stats, update UI, and emit trade complete signal
#func trade(customer: PlayerEntity) -> void:
	#var order = Global.orders_dict[customer]
	#var product = order["product"]
	#var num_ordered = order["number"]
	#var inventory = plant.get_plants_dict()[product]["current"]
		#
		#
	#if plant.get_plants_dict().has(product) and inventory["plants_on_hand"] >= order["number"]:
		#inventory["plants_on_hand"] -= num_ordered
		#inventory["seeds"] += 2
		#order["order_completed"] = true
	#else:
		## TODO: audio/visual indicator why trade failed
		#print(str(product) + ": item not found in inventory.")
