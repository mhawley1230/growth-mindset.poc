extends CharacterBody2D

@export var move_speed: float = 100
@onready var input_direction: Vector2

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


	
