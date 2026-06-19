class_name CursorPositionComponent
extends Node

## Snaps the cursor one half-tile ahead of the body in the input direction.
func handle_cursor_position(
		character_body: CharacterBody2D,
		cursor: Area2D,
		input_dir: Vector2,
	) -> void:
	if input_dir == Vector2.ZERO:
		return
	var tile: Vector2 = Vector2(GameConstants.TILE_SIZE, GameConstants.TILE_SIZE)
	var cursor_direction: Vector2 = input_dir * (tile / 2.0)
	cursor.global_position = snapped(character_body.global_position + cursor_direction, tile)
