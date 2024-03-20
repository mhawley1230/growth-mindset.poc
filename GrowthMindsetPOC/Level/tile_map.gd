extends TileMap

@onready var grass_tile: CompressedTexture2D = preload("res://Assets/grass_tile.png")
@export var grid_size_x: int = 4
@export var grid_size_y: int = 4
var dict: Dictionary = {}
#
## Called when the node enters the scene tree for the first time.
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
#
