class_name CursorPositionComponent
extends Node

#@onready var tile_size: Vector2 = Utils.TILE_SIZE
#
#func handle_cursor_position(character_body: CharacterBody2D, cursor: Area2D, input_dir: Vector2) -> void:
	#var cursor_direction: Vector2 = input_dir * (tile_size / 2)
	#if input_dir != Vector2.ZERO:
		#cursor.global_position = snapped(character_body.global_position + cursor_direction, tile_size)
