class_name CursorMovementHandler
extends Node

@onready var tile_size = GlobalVars.TILE_SIZE

func handle_cursor_position(character_body: CharacterBody2D, input_dir: Vector2, cursor: CursorEntity) -> void:
	#TODO: rewrite as a function
	
	var grid_pos = Vector2i(int(character_body.global_position.x) / tile_size.x, int(character_body.global_position.y) / tile_size.y)
	cursor.global_position = Vector2i(snappedi(grid_pos.x * tile_size.x, tile_size.x), snappedi(grid_pos.y * tile_size.y, tile_size.y))
	pass
