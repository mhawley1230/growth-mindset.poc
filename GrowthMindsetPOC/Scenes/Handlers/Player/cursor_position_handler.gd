class_name CursorMovementHandler
extends Node

@onready var tile_size = GlobalVars.TILE_SIZE

func handle_cursor_position(character_body: CharacterBody2D, cursor: CursorEntity) -> void:
	
	# Set cursor position relative to character, snapping to (32,32) tile grid
	# as player moves freely
	var grid_pos = Vector2i(int(character_body.global_position.x) / tile_size.x, int(character_body.global_position.y) / tile_size.y)
	cursor.global_position = Vector2i(snappedi(grid_pos.x * tile_size.x, tile_size.x), snappedi(grid_pos.y * tile_size.y, tile_size.y))
	pass
