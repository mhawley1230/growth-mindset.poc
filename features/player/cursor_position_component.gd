class_name CursorPositionComponent
extends Node

## Direction the body last moved in, used to keep the cursor on the correct
## side of the body even on frames with no fresh input (e.g. the body is
## still sliding from residual velocity or a collision).
var _last_facing: Vector2 = Vector2.DOWN

## Keeps the cursor snapped to a tile close to the body: the body's own
## tile center while it's in the first half of that tile, and the adjacent
## tile's center (in the direction the body is/was facing) once the body
## crosses its tile's center point.
##
## This is done by biasing the body's position half a tile toward its
## facing direction before flooring it to a tile index. That bias is what
## moves the transition point from the tile's edge to its center: the tile
## index only ticks over once `position + facing * tile/2` pushes past the
## next multiple of the tile size, which happens exactly when `position`
## itself passes the center of the current tile. Using floor() (not
## round()/snapped()) keeps that transition unambiguous regardless of which
## half of a tile the body's continuous position happens to be in. Because
## this runs every physics frame off the body's live position (not gated on
## input_dir), the cursor keeps tracking correctly even while the body is
## still moving.
func handle_cursor_position(
		character_body: CharacterBody2D,
		cursor: Area2D,
		input_dir: Vector2,
	) -> void:
	if input_dir != Vector2.ZERO:
		_last_facing = input_dir.sign()

	var tile: Vector2 = Vector2(GameConstants.TILE_SIZE, GameConstants.TILE_SIZE)
	var biased_position: Vector2 = character_body.global_position + _last_facing * (tile / 2.0)
	var target_tile: Vector2 = (biased_position / tile).floor() * tile
	cursor.global_position = target_tile + tile / 2.0
