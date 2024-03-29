extends Node2D

@onready var player = get_tree().root.get_node("GameLevel/UI/Player")
@onready var tile_map = get_tree().root.get_node("GameLevel/UI/TileMap")
@onready var tile = Tile.new()
@onready var tile_size = tile.TILE_SIZE
@onready var offset = Vector2(tile_size / 4, tile_size / 4)


func _process(_delta):
	var input = player.move()
	var grid_pos = tile_map.local_to_map(player.get_position())
	var local_grid_pos = tile_map.map_to_local(grid_pos)
	 
	if input != Vector2.ZERO:
		position = snapped(local_grid_pos + (input * offset), Vector2(tile_size, tile_size))
