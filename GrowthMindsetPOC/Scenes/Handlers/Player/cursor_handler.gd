class_name CursorHandler
extends Node

var tile_size: Vector2 = Vector2(32, 32)
var position_locked: bool = false
var offset: Vector2 = Vector2(16, 16)
var direction: Vector2 = Vector2.ZERO


func handle_cursor_position(character_body: CharacterBody2D, input_dir: Vector2, cursor: CursorEntity) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		if input_dir.x < 0 and not position_locked:
				cursor.global_position = character_body.position - Vector2(offset.x, 0)
		
		if input_dir.x > 0 and not position_locked:
				cursor.global_position = character_body.position + Vector2(offset.x, 0)
		
		if input_dir.y < 0 and not position_locked:
				cursor.global_position = character_body.position - Vector2(0, offset.y)
		
		if input_dir.y > 0 and not position_locked:
				cursor.global_position = character_body.position + Vector2(0, offset.y)
		
		position_locked = true
	
	cursor.global_position = snapped(cursor.global_position, tile_size)
	position_locked = false
