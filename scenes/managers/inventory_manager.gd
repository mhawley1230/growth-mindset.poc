class_name InventoryManager
extends Node

@onready var _contents: Dictionary = {}


func _ready():
	SignalBus.on_inventory_manager_ready.emit(self)
	Global.inventory_manager = self


func add_inventory(category: String, product: String, num: int) -> Dictionary:
	if !_contents.has(category):
		_contents[category] = { product: num }
		
	if !_contents[category].has(product):
		_contents[category][product] = num
	
	return get_inventory(category, product)


func remove_inventory(category: String, product: String, num: int) -> Dictionary:
	_contents[category][product] -= num
	return get_inventory(category, product)


func get_inventory(category: String, product: String) -> Dictionary:	
	for i in _contents[category].keys():
		if i == product:
			return { i: _contents[category][i] }
	return {}


func get_all_inventory() -> Dictionary:
	return _contents


func clear_inventory() -> void:
	return _contents.clear()
