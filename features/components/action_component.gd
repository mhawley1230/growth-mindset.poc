class_name ActionComponent
extends Node

#region inventory
#@onready var manager_container: Node = NodeExtensions.get_manager_container()
#@onready var inventory_manager: InventoryManager = Global.inventory_manager
#endregion

@export var available_plants: Array[PackedScene] = []

var trading_enabled: bool = false
var customer_in_trade_area: bool = false
var current_order: Dictionary = {}
var num_created: int = 0


func detect_overlapped_areas(target: Area2D) -> Array[Area2D]:
	return target.get_overlapping_areas()


func is_planting_enabled(areas: Array[Area2D]) -> bool:
	var enabled: bool = false

	for area: Area2D in areas:
		if area is FarmPlot and areas.size() == 1:
			enabled = true

	return enabled

# Trade-area state is pushed in by the level wiring (TradeArea / CustomerQueue
# local signals -> these setters) instead of the old global SignalBus.
func set_trading_enabled(enabled: bool) -> void:
	trading_enabled = enabled

func set_customer_in_trade_area(present: bool) -> void:
	customer_in_trade_area = present

func set_current_order(order: Dictionary) -> void:
	current_order = order

## Fires a trade only when a customer is in range; delegates the inventory
## mutation to TradingComponent. Safe no-op until the customer system is wired.
func try_trade(trading_component: TradingComponent, inventory: InventoryController) -> bool:
	if not (trading_enabled and customer_in_trade_area):
		return false
	return trading_component.execute(current_order, inventory)


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
