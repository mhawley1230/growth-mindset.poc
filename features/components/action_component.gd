class_name ActionComponent
extends Node

var trading_enabled: bool = false
var customer_in_trade_area: bool = false
var current_order: Dictionary = {}
var num_created: int = 0


func detect_overlapped_areas(target: Area2D) -> Array[Area2D]:
	return target.get_overlapping_areas()


func is_planting_enabled(areas: Array[Area2D]) -> bool:
	var enabled: bool = false
	
	for area: Area2D in areas:
		if area.is_in_group("farm_plot") and areas.size() == 1:
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
## mutation to TradingComponent. Clears the order on success so the same order
## can't be re-traded on a repeat press while the customer is still in range.
func try_trade(trading_component: TradingComponent, inventory: InventoryController) -> bool:
	if not (trading_enabled and customer_in_trade_area):
		return false
	var success: bool = trading_component.execute(current_order, inventory)
	if success:
		current_order = {}
	return success
