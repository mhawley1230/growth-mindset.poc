class_name MovementHandler
extends Node2D

@export var movement_speed: int = 300

func handle_movement(character_body: CharacterBody2D, input_dir: Vector2) -> void:
	handle_deceleration(character_body)
	
	if input_dir.x < 0:
		character_body.velocity.x = -movement_speed
	
	if input_dir.x > 0:
		character_body.velocity.x = movement_speed
		
	if input_dir.y < 0:
		character_body.velocity.y = -movement_speed
	
	if input_dir.y > 0:
		character_body.velocity.y = movement_speed


func handle_deceleration(character_body: CharacterBody2D) -> void:
	character_body.velocity = Vector2(0,0)
