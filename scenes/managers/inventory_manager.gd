class_name InventoryManager
extends Node

@onready var _contents: Dictionary = {}

func _init():
	Global.inventory_manager = self


func _ready():
	SignalBus.on_inventory_manager_ready.emit(self)
	


func add_inventory(category: String, product: String, num: int):
	if !_contents.has(category):
		_contents[category] = { product: num }
		
	if !_contents[category].has(product):
		_contents[category][product] = num
	
	handle_inventory_update_signal(category, product, num)


func remove_inventory(category: String, product: String, num: int):
	_contents[category][product] -= num
	
	handle_inventory_update_signal(category, product, num)


func get_inventory(category: String, product: String) -> Dictionary:
	for i in _contents[category].keys():
		if i == product:
			return { i: _contents[category][i] }
	return {}


func get_all_inventory() -> Dictionary:
	return _contents


func clear_inventory() -> Dictionary:
	_contents = {}
	return _contents


func handle_inventory_update_signal(category: String, product: String, num: int):
	match category:
		"plants":
			SignalBus.emit_on_plant_inventory_updated(product, num)
		"seeds":
			SignalBus.emit_on_seed_inventory_updated(product, num)
