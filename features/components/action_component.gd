class_name ActionComponent
extends Node

#region inventory
#@onready var manager_container: Node = NodeExtensions.get_manager_container()
#@onready var inventory_manager: InventoryManager = Global.inventory_manager
#endregion

@export var available_plants: Array[PackedScene] = []

var trading_enabled: bool = false
var customer_in_trade_area: bool = false
var num_created: int = 0


#func _ready() -> void:
	#SignalBus.on_trade_area_entered.connect(on_trade_area_entered)
	#SignalBus.on_trade_area_exited.connect(on_trade_area_exited)
	#SignalBus.on_customer_trade_area_entered.connect(on_customer_trade_area_entered)
	
	#if manager_container == null:
		#return
	
	#inventory_manager = manager_container.get_node("InventoryManager")


func detect_overlapped_areas(target: Area2D) -> Array[Area2D]:
	return target.get_overlapping_areas()


func is_planting_enabled(areas: Array[Area2D]) -> bool:
	var enabled: bool = false
	
	for area: Area2D in areas:
		if area is FarmPlot and areas.size() == 1:
			enabled = true
		
	return enabled

## TODO: Refactor: 
##    1. Create trade area for player [COMPLETE]
##    2. Trade area is child of farm stand [COMPLETE]
##    3. Enable trading when: CustomerEntity is in
##    CustomerWaitArea, player is in PlayerTradeArea
##    4. Update inventory - add/remove functions
##    5. Update local stats
##    6. Update global stats
##    7. Emit trade complete signal

func trade(giving: Dictionary) -> void:
	for item: PlantData in giving:
		print(item)
	#inventory.remove_inventory("plants", item, item.value())
	#inventory.remove_inventory("plants", "tomato", 1)
	#inventory.add_inventory("seeds", "tomato", 2)
	#SignalBus.emit_on_trade_complete()


func on_trade_area_entered(area: Area2D) -> void:
	## Look for customer entity in wait area
	print(area.get_overlapping_bodies())
	for body:CharacterBody2D in area.get_overlapping_bodies():
		if body.is_in_group("customer"):
			print("customer detected, trading enabled")
			trading_enabled = true


func on_customer_trade_area_entered(area: Area2D, _customer: CharacterBody2D) -> void:
	## Look for customer entity in wait area
	for body: CharacterBody2D in area.get_overlapping_bodies():
		if body.is_in_group("customer"):
			customer_in_trade_area = true


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
