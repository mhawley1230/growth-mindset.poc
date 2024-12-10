class_name PlayerEntity
extends CharacterBody2D

#region Player
@onready var input_handler := $InputHandlerComponent
@onready var movement_handler := $MovementHandlerComponent
@onready var action_handler := $ActionHandlerComponent
#endregion

#region Cursor
@onready var cursor: Area2D = $Cursor
@onready var cursor_position_handler := $CursorPositionHandlerComponent
#endregion

func _ready() -> void:
	NodeExtensions.get_entity_container()
	SignalBus.emit_on_player_ready(self)


func _physics_process(_delta) -> void:
	movement_handler.handle_movement(self, input_handler.handle_movement())
	move_and_slide()
	cursor_position_handler.handle_cursor_position(self, cursor, input_handler.handle_movement())


#func _input(_event) -> void:
	#if input_handler.handle_action_1_input():
		#if action_handler.is_planting_enabled(action_handler.detect_overlapped_areas(cursor)):
			#action_handler.create_plant(0, cursor.global_position)
#
	#if input_handler.handle_action_2_input():
		#action_handler.harvest_plant(action_handler.detect_overlapped_areas(cursor))
		#
	#if input_handler.handle_action_3_input():
		#if action_handler.trading_enabled && action_handler.customer_in_trade_area:
			#action_handler.trade(action_handler.get_customer_order())
		
	#if input_handler.handle_action_4_input():
		#print("action 4 pressed")
