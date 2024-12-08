class_name ActionHandler
extends Node

@export var available_plants: Array[PackedScene] = []

var trading_enabled: bool = false
var num_created: int = 0

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
	var plant_instance: String = new_plant.name + "_" + str(new_plant.get_instance_id())
	new_plant.name = plant_instance
	var plant_type = Globals.strip_instance_id(plant_instance)
	
	
	if Inventory.get_inventory("seeds", plant_type) < 1:
		print("not enough seeds")
		return
	#
	entity_container.add_child(new_plant)
	new_plant.position = Vector2i(spawn_position)
	Inventory.remove_inventory("seeds", plant_type, 1)


func harvest_plant(areas: Array[Area2D]) -> void:
	for area in areas:
		if area.is_in_group("plant"):
			var plant_type = Globals.strip_instance_id(area.name)
			Inventory.add_inventory("plants", plant_type, 1)
			area.free()

## TODO: Refactor: 
##    1. Create trade area for player [COMPLETE]
##    2. Trade area is child of farm stand [COMPLETE]
##    3. Enable trading when: CustomerEntity is in
##    CustomerWaitArea, player is in PlayerTradeArea
##    4. Update Inventory - add/remove functions
##    5. Update local stats
##    6. Update global stats
##    7. Emit trade complete signal

func trade() -> void:
	#Inventory.remove_inventory("plants", "tomato", 1)
	#Inventory.add_inventory("seeds", "tomato", 2)
	
	SignalBus.emit_on_trade_complete()


func on_trade_area_entered(area) -> void:
	trading_enabled = true
	
	## Look for customer entity in wait area
	for body in area.get_overlapping_bodies():
		print(body)


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
