class_name PlayerEntity
extends CharacterBody2D

#region Player handlers
@onready var input_handler = $HandlerContainer/InputHandler as InputHandler
@onready var movement_handler = $HandlerContainer/MovementHandler as MovementHandler
@onready var action_handler = $HandlerContainer/ActionHandler as ActionHandler
#endregion

#region Cursor entity and handlers
@onready var cursor = $CursorEntity as CursorEntity
@onready var cursor_position_handler = $CursorEntity/HandlerContainer/CursorPositionHandler as CursorPositionHandler
#endregion

func _ready() -> void:
	NodeExtensions.get_entity_container()
	SignalBus.emit_on_player_ready(self)


func _physics_process(_delta) -> void:
	movement_handler.handle_movement(self, input_handler.handle_movement())
	move_and_slide()
	cursor_position_handler.handle_cursor_position(self, cursor, input_handler.handle_movement())


func _input(_event) -> void:
	if input_handler.handle_action_1_input():
		if action_handler.is_planting_enabled(action_handler.detect_overlapped_areas(cursor)):
			action_handler.create_plant(0, cursor.global_position)

	if input_handler.handle_action_2_input():
		action_handler.harvest_plant(action_handler.detect_overlapped_areas(cursor))
		
	if input_handler.handle_action_3_input():
		if action_handler.trading_enabled:
			action_handler.trade()
		
	#if input_handler.handle_action_4_input():
		#print("action 4 pressed")
