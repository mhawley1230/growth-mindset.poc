class_name InventoryController
extends Node

signal on_inventory_updated

var _game_state_holder: GameStateHolder

func bind_services(game_state_holder: GameStateHolder) -> void:
	_game_state_holder = game_state_holder

func setup() -> void:
	on_inventory_updated.emit()

func reset() -> void:
	var inv: Dictionary[String, Dictionary] = _inventory()
	if inv.is_empty():
		return
	inv["seeds"].clear()
	inv["plants"].clear()
	on_inventory_updated.emit()

func add(category: String, product: String, amount: int) -> void:
	var inv: Dictionary[String, Dictionary] = _inventory()
	if not inv.has(category):
		return
	var cat: Dictionary[String, int] = _typed_category(inv, category)
	cat[product] = _count(cat, product) + amount
	on_inventory_updated.emit()

func remove(category: String, product: String, amount: int) -> bool:
	var inv: Dictionary[String, Dictionary] = _inventory()
	if not inv.has(category):
		return false
	var cat: Dictionary[String, int] = _typed_category(inv, category)
	var current: int = _count(cat, product)
	if current < amount:
		return false
	cat[product] = current - amount
	on_inventory_updated.emit()
	return true

func get_count(category: String, product: String) -> int:
	var inv: Dictionary[String, Dictionary] = _inventory()
	if not inv.has(category):
		return 0
	return _count(_typed_category(inv, category), product)

func get_category(category: String) -> Dictionary:
	var inv: Dictionary[String, Dictionary] = _inventory()
	if not inv.has(category):
		return {}
	return inv[category]

func _inventory() -> Dictionary[String, Dictionary]:
	if _game_state_holder == null or _game_state_holder.game_state == null:
		return {}
	return _game_state_holder.game_state.inventory

## inv[category] is only statically known as "Dictionary" (the outer
## dictionary's declared value type -- GDScript doesn't support nesting typed
## generics like Dictionary[String, Dictionary[String, int]]). Every category
## is actually built as Dictionary[String, int] in GameState, so this casts
## it back in one place instead of at every call site.
func _typed_category(inv: Dictionary[String, Dictionary], category: String) -> Dictionary[String, int]:
	return inv[category] as Dictionary[String, int]

## Dictionary.get() always returns a plain Variant, even when called on a
## typed dictionary, so passing it straight into int() is still an unsafe
## call. Validating with has() first lets the fallback-to-0 case be explicit,
## and the subsequent subscript read stays statically typed as int.
func _count(cat: Dictionary[String, int], product: String) -> int:
	if not cat.has(product):
		return 0
	return cat[product]
