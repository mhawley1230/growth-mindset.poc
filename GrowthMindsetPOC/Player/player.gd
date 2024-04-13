extends CharacterBody2D

@export var move_speed: float = 100
@onready var input_direction: Vector2
@onready var cur = get_tree().root.get_node("GameLevel/UI/Cursor")

var cur_pos: Vector2
var positions_arr: Array

func _process(_delta):
	move()
	move_and_slide()
	
func move():
	input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	velocity = input_direction.normalized() * move_speed
	
	return input_direction
	
func _input(_event):
	if Input.is_action_just_pressed("action_1"):
		if !Plants.is_plant_at_position() and cur.is_cursor_within_farm_plot():
			Plants.create_plant(0)
	if Input.is_action_just_pressed("action_2"):
		if !Plants.is_plant_at_position() and cur.is_cursor_within_farm_plot(): 
			Plants.create_plant(1)
	if Input.is_action_just_pressed("action_3"):
		if Plants.is_plant_at_position():
			Plants.harvest()
			

	

	
	
	
	
	
