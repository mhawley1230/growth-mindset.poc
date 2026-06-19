class_name InventoryController
extends Node

signal on_inventory_updated

var _game_state_holder: GameStateHolder

func bind_services(game_state_holder: GameStateHolder) -> void:
	_game_state_holder = game_state_holder

func setup() -> void:
	on_inventory_updated.emit()

func reset() -> void:
	var inv: Dictionary = _inventory()
	if inv.is_empty():
		return
	inv["seeds"].clear()
	inv["plants"].clear()
	on_inventory_updated.emit()

func add(category: String, product: String, amount: int) -> void:
	var inv: Dictionary = _inventory()
	if not inv.has(category):
		return
	var cat: Dictionary = inv[category]
	cat[product] = int(cat.get(product, 0)) + amount
	on_inventory_updated.emit()

func remove(category: String, product: String, amount: int) -> bool:
	var inv: Dictionary = _inventory()
	if not inv.has(category):
		return false
	var cat: Dictionary = inv[category]
	var current: int = int(cat.get(product, 0))
	if current < amount:
		return false
	cat[product] = current - amount
	on_inventory_updated.emit()
	return true

func get_count(category: String, product: String) -> int:
	var inv: Dictionary = _inventory()
	if not inv.has(category):
		return 0
	return int(inv[category].get(product, 0))

func get_category(category: String) -> Dictionary:
	var inv: Dictionary = _inventory()
	if not inv.has(category):
		return {}
	return inv[category]

func _inventory() -> Dictionary:
	if _game_state_holder == null or _game_state_holder.game_state == null:
		return {}
	return _game_state_holder.game_state.inventory
