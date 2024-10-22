class_name ActionHandler
extends Node

@export var available_plants: Array[PackedScene] = []

var trading_enabled: bool = false

func _ready() -> void:
	SignalBus.on_trade_area_entered.connect(on_trade_area_entered)
	SignalBus.on_trade_area_exited.connect(on_trade_area_exited)


func detect_overlapped_areas(target: Area2D) -> Array[Area2D]:
	return target.get_overlapping_areas()


func is_planting_enabled(areas: Array[Area2D]) -> bool:
	var enabled: bool = false
	
	for area in areas:
		if area is FarmPlot and areas.size() == 1:
			enabled = true
		
	return enabled


func create_plant(index: int, spawn_position: Vector2) -> void:	
	var entity_container: Node = NodeExtensions.get_entity_container()
	if entity_container == null:
		return
	
	var new_plant: Node2D = available_plants[index].instantiate()
	var new_plant_name: String = new_plant.name.to_lower()
	
	if Inventory.get_inventory("seeds", new_plant_name) == 1:
		print("not enough seeds")
		return
	
	entity_container.add_child(new_plant)
	new_plant.position = Vector2i(spawn_position)
	Inventory.remove_inventory("seeds", new_plant_name, 1)


func harvest_plant(areas: Array[Area2D]) -> void:
	pass
	#for area in areas:
			# Inventory.add_inventory("plant", area.name, 1)
			#area.free()

## TODO: Refactor: 
##    1. Create trade area for player
##    2. Trade area is child of farm stand
##    3. Enable trading when: CustomerEntity is in CustomerWaitArea, 
##         player is in PlayerTradeArea
##    4. Transact, update global stats, update UI, and emit trade complete signal
func trade() -> void:
	#Inventory.inventory["tomatoes"]["in_inventory"] -= 1
	#Inventory.inventory["tomatoes"]["seeds_in_inventory"] += 2
	SignalBus.emit_on_trade_complete()


func on_trade_area_entered() -> void:
	trading_enabled = true


func on_trade_area_exited() -> void:
	trading_enabled = false


## TODO: Figure out way to swap types of seeds in action bar
##     - What button should this be on?
##     - How are seed types stored in action bar?
##     - What variables are accessed? 
##     - What data structure works best?
##
## func swap_seed_type() -> void:
##     1. Access seeds data object
##     2. Increment index/key of array, list, ect.
##     3. Update action bar visuals
