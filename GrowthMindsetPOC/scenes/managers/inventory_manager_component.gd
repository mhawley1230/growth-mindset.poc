class_name InventoryManagerComponent
extends Node

@onready var level: Level = null
@onready var available_products: Array[Plant] = []
@onready var _contents: Dictionary = {}


func _ready():
	SignalBus.on_level_ready.connect(on_level_ready)


func add_inventory(category: String, product: String, num: int) -> void:
	_contents[category][product] += num


func remove_inventory(category: String, product: String, num: int) -> void:
	if has_inventory(category, product):
		_contents[category][product] -= num


func has_inventory(category: String, product: String) -> bool:
	if _contents[category][product] >= 1:
		return true
	return false


func create_inventory(category: String, product: String, num: int) -> void:
	_contents[category][product] = num


func get_inventory(category: String, product: String) -> int:
	if has_inventory(category, product):
		return _contents[category][product]
	return 0


func get_all_inventory() -> Dictionary:
	return _contents


func clear_inventory() -> void:
	_contents = {
		"seeds": {},
		"plants": {}
	}

func on_level_ready(loaded_level: Level):
	level = loaded_level
	available_products = level.available_products
	print(available_products)
	
