class_name PlayerEntity
extends CharacterBody2D

# Player handlers
@onready var input_handler = $HandlerContainer/InputHandler as InputHandler
@onready var movement_handler = $HandlerContainer/MovementHandler as MovementHandler
@onready var action_handler = $HandlerContainer/ActionHandler as ActionHandler

# Cursor entity and handlers
@onready var cursor = $CursorEntity as CursorEntity
@onready var cursor_position_handler = $CursorEntity/HandlerContainer/CursorPositionHandler as CursorPositionHandler


func _ready() -> void:
	NodeExtensions.get_entity_container()


func _physics_process(_delta) -> void:
	movement_handler.handle_movement(self, input_handler.handle_movement())
	move_and_slide()
	cursor_position_handler.handle_cursor_position(self, cursor)


func _input(_event) -> void:
	if input_handler.handle_action_1_input() && \
		action_handler.is_planting_enabled(action_handler.detect_overlapped_areas(cursor)):
		action_handler.create_plant(0, cursor.global_position)

	if input_handler.handle_action_2_input():
		action_handler.harvest_plant(action_handler.detect_overlapped_areas(cursor))
		
	#if input_handler.handle_action_3_input():
		#print("action 3 pressed")
	#if input_handler.handle_action_4_input():
		#print("action 4 pressed")
