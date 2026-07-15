class_name InputComponent
extends Node


func handle_create_plant_input() -> bool:
	return Input.is_action_just_pressed("create_plant")


func handle_harvest_plant_input() -> bool:
	return Input.is_action_just_pressed("harvest_plant")


func handle_trade_input() -> bool:
	return Input.is_action_just_pressed("trade")


func handle_action_4_input() -> bool:
	return Input.is_action_just_pressed("action_4")


func handle_movement() -> Vector2:
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	return input_direction


func handle_swap_plant_input() -> bool:
	return Input.is_action_just_pressed("swap_plant")
