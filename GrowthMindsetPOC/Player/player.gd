extends CharacterBody2D

@export var move_speed: float = 100
@onready var input_direction: Vector2
var tile_size = 32

func _process(_delta):
	move()
	getPositionOnGrid()
	move_and_slide()
	
func move():
	input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	velocity = input_direction.normalized() * move_speed
	
	return input_direction

func getPositionOnGrid():
	var pos: Vector2
	var pos_x = str(int(position.x / tile_size))
	var pos_y = str(int(position.y / tile_size))
	
	var tilemap = get_tree().root.get_node("GameLevel/UI/TileMap")
	var map_dict = tilemap.create_map()
	#print(map_dict)
	if map_dict.has("(" + pos_x + ", " + pos_y + ")"):
		pos = Vector2(int(pos_x),int(pos_y))
	
	return pos
	
