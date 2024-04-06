extends TileMap

class_name Tile

@export var grid_size_x: int = 100
@export var grid_size_y: int = 60

@onready var grass_tile: CompressedTexture2D = preload("res://Assets/grass_tile.png")
@onready var tilemap = get_tree().root.get_node("GameLevel/UI/TileMap")
@onready var player = get_tree().root.get_node("GameLevel/UI/Player")

var dict: Dictionary = {}

var TILE_SIZE: int = Global.TILE_SIZE

func _ready():
	create_map()
	
	
func create_map():
	for x in grid_size_x:
		for y in grid_size_y:
			dict[str(Vector2(x,y))] = {
				"Type": "Grass"
			}
			set_cell(0, Vector2(x,y), 0, Vector2i(0,0), 0)
	return dict
	
	
func get_grid_coords_from_pos(pos: Vector2):
	@warning_ignore("integer_division")
	var x = str(int(pos.x) / TILE_SIZE)
	@warning_ignore("integer_division")
	var y = str(int(pos.y) / TILE_SIZE)
	
	if dict.has("(" + x + ", " + y + ")"):
		return x + ", " + y
		
