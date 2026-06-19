class_name TradingComponent
extends Node

signal trade_completed

## Seeds returned per plant handed over (placeholder payment model until a
## currency / value system exists; PlantData.value can drive this later).
const SEED_REWARD: int = 2

## Executes a trade if the player holds every ordered plant. order is keyed by
## product name: { "tomato": 2, "potato": 1 }.
func execute(order: Dictionary, inventory: InventoryController) -> bool:
	if inventory == null or order.is_empty():
		return false

	# Validate the whole order first so partial trades never happen.
	for product: String in order:
		if inventory.get_count("plants", product) < int(order[product]):
			return false

	for product: String in order:
		var qty: int = int(order[product])
		inventory.remove("plants", product, qty)
		inventory.add("seeds", product, qty * SEED_REWARD)

	trade_completed.emit()
	return true
