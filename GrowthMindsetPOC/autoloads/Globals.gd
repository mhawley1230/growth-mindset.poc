extends Node

const TILE_SIZE: Vector2 = Vector2i(32, 32)

func strip_instance_id(input: String) -> String:
	return input.split("_")[0].to_lower()
