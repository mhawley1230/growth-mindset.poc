class_name CursorHandler
extends Node

@export var tile_size: Vector2i = Vector2i(32, 32)
var position_locked: bool = true
var direction: Vector2 = Vector2.ZERO


func handle_cursor_position(character_body: CharacterBody2D, input_dir: Vector2, cursor: CursorEntity) -> void:
	## get character direction
	direction = input_dir
	var grid_pos = Vector2i(int(character_body.global_position.x) / tile_size.x, int(character_body.global_position.y) / tile_size.y)
	#print(str(grid_pos) + ", " + str(grid_pos * tile_size))
	cursor.global_position = Vector2i(snappedi(grid_pos.x * tile_size.x, tile_size.x), snappedi(grid_pos.y * tile_size.y, tile_size.y))
	
	#if input_dir.x < 0 and not position_locked:
			#cursor.global_position = snapped(character_body.global_position, tile_size)
	#
	#if input_dir.x > 0 and not position_locked:
			#cursor.global_position = snapped(character_body.global_position, tile_size)
	#
	#if input_dir.y < 0 and not position_locked:
			#cursor.global_position = snapped(character_body.global_position, tile_size)
	#
	#if input_dir.y > 0 and not position_locked:
			#cursor.global_position = snapped(character_body.global_position, tile_size)
