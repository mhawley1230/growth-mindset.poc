class_name InventoryController
extends Node

signal on_inventory_updated

var _game_state_holder: GameStateHolder

#var _contents: Dictionary = {}

func bind_services(game_state_holder: GameStateHolder) -> void:
	_game_state_holder = game_state_holder

func setup() -> void:
	on_inventory_updated.emit()

#func add_inventory(category: String, product: String, num: int) -> Dictionary:
	#if !_contents.has(category):
		#_contents[category] = { product: num }
		#
	#if !_contents[category].has(product):
#func _init() -> void:
	#Global.inventory_manager = self
#
#
#func _ready() -> void:
	#SignalBus.on_inventory_manager_ready.emit(self)
#
		#_contents[category][product] = num
	#
	#handle_inventory_update_signal(category, product, num)
	#return get_inventory(category, product)
#
#
#func remove_inventory(category: String, product: String, num: int) -> Dictionary:
	#_contents[category][product] -= num
	#
	#handle_inventory_update_signal(category, product, num)
	#return get_inventory(category, product)
#
#
#func get_inventory(category: String, product: String) -> Dictionary:
	#for key: String in _contents[category].keys():
		#if key == product:
			#return { key: _contents[category][key] }
	#return { product : 0 }
#
#
#func get_all_inventory() -> Dictionary:
	#return _contents
#
#
#func clear_inventory() -> Dictionary:
	#_contents = {}
	#return _contents
#
#
#func handle_inventory_update_signal(
			#category: String, 
			#product: String, 
			#num: int
		#) -> void:
	#match category:
		#"plants":
			#SignalBus.emit_on_plant_inventory_updated(product)
		#"seeds":
			#SignalBus.emit_on_seed_inventory_updated(product)
