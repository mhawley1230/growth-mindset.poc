class_name InventoryManager
extends Node

@onready var _contents = {
	"seeds": {},
	"plants": {}
}


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
