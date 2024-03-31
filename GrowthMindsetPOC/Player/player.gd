extends CharacterBody2D

@export var move_speed: float = 100

@onready var input_direction: Vector2
@onready var tomato = preload("res://Level/Plants/tomato.tscn")

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
	
func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.as_text() == "Z":
			create_plant()
			
func create_plant():
	var offset = Vector2(16, 16)
	var cur_pos = get_tree().root.get_node("GameLevel/UI/Cursor").position
	var plant_holder = get_tree().root.get_node("GameLevel/UI/Farm/PlantHolder")
	var temp_tomato = tomato.instantiate()
	plant_holder.add_child(temp_tomato)
	var current_tom = plant_holder.get_child(-1)
	current_tom.set_position(cur_pos + offset)
	
	
	
