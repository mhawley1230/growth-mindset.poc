extends CharacterBody2D

@export var move_speed: float = 100

@onready var input_direction: Vector2
@onready var tomato = preload("res://Level/Plants/tomato.tscn")
@onready var cur = get_tree().root.get_node("GameLevel/UI/Cursor")

var cur_pos: Vector2
var positions_arr: Array

func _process(_delta):
	cur_pos = cur.position
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
			if !isPlantAtPosition(cur_pos):
				create_plant()
			
func create_plant():
	var plant_holder = get_tree().root.get_node("GameLevel/UI/Farm/PlantHolder")
	var temp_plant = tomato.instantiate()
	
	temp_plant.name = "Tomato" + str(plant_holder.get_child_count())
	plant_holder.add_child(temp_plant)
	temp_plant.set_position(cur_pos)
	positions_arr.append(temp_plant.position)
	temp_plant.get_node("AnimationPlayer").play("grow_anim")
	
func isPlantAtPosition(pos: Vector2):
	if positions_arr.is_empty() != true:
		for position in positions_arr:
			if position == cur_pos:
				return true
	return false
	
	
	
	
	
