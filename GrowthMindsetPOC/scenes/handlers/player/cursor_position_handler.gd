class_name CursorPositionHandler
extends Node

@onready var tile_size = GlobalVars.TILE_SIZE

## TODO: Refactor this. How could this function better?
##    Player character facing direction vs static character w/ cursor
##    pointing at last direction moved

func handle_cursor_position(character_body: CharacterBody2D, cursor: CursorEntity, input_dir: Vector2) -> void:
	
	var cursor_direction: Vector2 = input_dir * (tile_size / 2)
	if input_dir != Vector2.ZERO:
		cursor.global_position = snapped(character_body.global_position + cursor_direction, tile_size)
