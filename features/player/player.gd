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

func bind_services(inventory_controller: InventoryController) -> void:
	_inventory_controller = inventory_controller

func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = input_component.handle_movement()
	movement_component.handle_movement(self, input_dir)
	move_and_slide()
	if cursor and cursor.cursor_position_component:
		cursor.cursor_position_component.handle_cursor_position(self, cursor, input_dir)

func _input(_event: InputEvent) -> void:
	if input_component.handle_action_1_input():
		var areas: Array[Area2D] = action_component.detect_overlapped_areas(cursor)
		if action_component.is_planting_enabled(areas):
			planting_component.create_plant(
				action_component.available_plants, cursor.global_position, _inventory_controller)

	if input_component.handle_action_2_input():
		harvesting_component.harvest_plant(
			action_component.detect_overlapped_areas(cursor), _inventory_controller)

	if input_component.handle_action_3_input():
		# Gated inside try_trade on trade-area state + a customer order, both pushed
		# in by the level once the customer system has scenes (see NOTES).
		action_component.try_trade(trading_component, _inventory_controller)

	if input_component.handle_action_4_input():
		print("action 4 pressed")
