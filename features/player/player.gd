class_name Player
extends CharacterBody2D

@onready var input_component: InputComponent = %InputComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var action_component: ActionComponent = %ActionComponent
@onready var planting_component: PlantingComponent = %PlantingComponent
@onready var harvesting_component: HarvestingComponent = %HarvestingComponent
@onready var trading_component: TradingComponent = %TradingComponent
@onready var cursor: Cursor = %Cursor

var _inventory_controller: InventoryController

## Level-configured crops (LevelContext.available_plants), read once at spawn
## time. _selected_plant_index tracks which one is currently active; swap_plant
## cycles it and logs the new selection to the console.
var _available_plants: Array[PlantData] = []
var _selected_plant_index: int = 0

func bind_services(inventory_controller: InventoryController,\
	available_plants: Array[PlantData] = []) -> void:
	_inventory_controller = inventory_controller
	_available_plants = available_plants
	_selected_plant_index = 0

func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = input_component.handle_movement()
	movement_component.handle_movement(self, input_dir)
	move_and_slide()
	if cursor and cursor.cursor_position_component:
		cursor.cursor_position_component.handle_cursor_position(self, cursor, input_dir)

func _input(_event: InputEvent) -> void:
	if input_component.handle_create_plant_input():
		var areas: Array[Area2D] = action_component.detect_overlapped_areas(cursor)
		if action_component.is_planting_enabled(areas):
			planting_component.create_plant(
				get_selected_plant(), cursor.global_position, _inventory_controller)

	if input_component.handle_harvest_plant_input():
		harvesting_component.harvest_plant(
			action_component.detect_overlapped_areas(cursor), _inventory_controller)

	if input_component.handle_action_3_input():
		# Gated inside try_trade on trade-area state + a customer order, both pushed
		# in by the level once the customer system has scenes (see NOTES).
		action_component.try_trade(trading_component, _inventory_controller)

	if input_component.handle_action_4_input():
		print("action 4 pressed")

	if input_component.handle_swap_plant_input():
		_swap_plant()

## Cycles the selected index into _available_plants and logs the new
## selection. No-op when the level hasn't configured any plants.
func _swap_plant() -> void:
	if _available_plants.is_empty():
		return
	_selected_plant_index = (_selected_plant_index + 1) % _available_plants.size()
	print("Selected plant: %s" % get_selected_plant().plant_name)

## The crop action_1 will plant, or null if the level configured none.
func get_selected_plant() -> PlantData:
	if _available_plants.is_empty():
		return null
	return _available_plants[_selected_plant_index]
