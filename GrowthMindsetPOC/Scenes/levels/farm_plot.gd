extends Area2D

@onready var tile_map = get_node("TileMap")
@onready var cells = tile_map.get_used_cells(0) 

func get_dimensions():
	var x = 0
	var y = 0
	
	for cell in cells:
		if cell.x >= x:
			x += 1
		if cell.y >= y:
			y += 1
		
	#return Vector2(x * Global.TILE_SIZE, y * Global.TILE_SIZE)
