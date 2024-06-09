class_name CursorPositionHandler
extends Node

var tile_size: Vector2 = Vector2(32, 32)
var offset: int = 16
var position_locked: bool = false
var direction: Vector2 = Vector2.ZERO

func handle_cursor_position(character_body: CharacterBody2D, input_dir: Vector2, cursor: Sprite2D) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		if input_dir.x < 0 and not position_locked:
				cursor.global_position = character_body.position - Vector2(offset, 0)
				#cursor.global_position = snapped(cursor.global_position, tile_size) 
		
		if input_dir.x > 0 and not position_locked:
				cursor.global_position = character_body.position + Vector2(offset, 0)
		
		if input_dir.y < 0 and not position_locked:
				cursor.global_position = character_body.position - Vector2(0, offset)
			
		if input_dir.y > 0 and not position_locked:
				cursor.global_position = character_body.position + Vector2(0, offset)
		
		position_locked = true
	
	cursor.global_position = snapped(cursor.global_position, tile_size)
	position_locked = false
	
	
