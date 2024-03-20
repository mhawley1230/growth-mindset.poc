extends Node2D

@onready var player = get_tree().root.get_node("GameLevel/UI/Player")
@onready var input = player.move() 
var tile_size = 32

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func _process(_delta):
	if player.move() != Vector2.ZERO:
		position += input * tile_size
	
1
