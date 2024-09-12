class_name CursorEntity
extends Area2D

func ready():
	SignalBus.emit_on_cursor_ready(self)

#@export var tile_size: Vector2i = Vector2i(32, 32)
#var position_locked: bool = true
#var direction: Vector2 = Vector2.ZERO


#func handle_cursor_position(character_body: CharacterBody2D, input_dir: Vector2, cursor: CursorEntity) -> void:
	#direction = input_dir
	#var grid_pos = Vector2i(int(character_body.global_position.x) / tile_size.x, int(character_body.global_position.y) / tile_size.y)
	#cursor.global_position = Vector2i(snappedi(grid_pos.x * tile_size.x, tile_size.x), snappedi(grid_pos.y * tile_size.y, tile_size.y))
#
#func detect_overlapped_areas(cursor: CursorEntity) -> Array[Area2D]:
	#var areas: Array[Area2D] = cursor.get_overlapping_areas()
	#
	#return areas
