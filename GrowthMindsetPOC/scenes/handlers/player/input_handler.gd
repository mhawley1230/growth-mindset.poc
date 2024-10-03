class_name InputHandler
extends Node


func handle_action_1_input() -> bool:
	return Input.is_action_just_pressed("action_1")


func handle_action_2_input() -> bool:
	return Input.is_action_just_pressed("action_2")


func handle_action_3_input() -> bool:
	return Input.is_action_just_pressed("action_3")


func handle_action_4_input() -> bool:
	return Input.is_action_just_pressed("action_4")


func handle_movement() -> Vector2:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	return input_direction
