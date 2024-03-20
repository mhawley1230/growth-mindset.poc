extends CharacterBody2D

@export var speed: int

@onready var mob_path: PathFollow2D
@onready var wait_point: Node2D
@onready var wait_point_pos: Vector2
@onready var progress: float
@onready var countdown: int = 3

func _ready():
	mob_path = get_tree().root.get_node("GameLevel/UI/PathSpawner/Stage/MobPath")
	wait_point = get_tree().root.get_node("GameLevel/UI/PathSpawner/Stage/MobPath/WaitPoint")
	
	
func _process(delta):
	mob_path.set_progress(mob_path.get_progress() + speed * delta)
	
	if wait_point is Node:
		wait_point_pos = wait_point.get_position()
	#print(get_position())
	
	
	if round_to_dec(mob_path.get_progress_ratio(), 2) == 0.50:
		var current_speed = 0
		speed = current_speed
		await get_tree().create_timer(countdown).timeout
		speed = 100
		#speed = 0
		#await timer(cooldown)
		get_node("Sprite2D").flip_h = true
		#speed = 100
		
		
	
	# TO DO: when halfway through track, stop and wait for "transaction" 
	
	
func timer(num : float):
	print("Timer start")
	await get_tree().create_timer(num).timeout
	print("Timer end")
	
		
func round_to_dec(num, decimals):
	num = float(num)
	decimals = int(decimals)
	var sgn = 1
	if num < 0:
			sgn = -1
			num = abs(num)
			pass
	var num_fraction = num - int(num) 
	var num_dec = round(num_fraction * pow(10.0, decimals)) / pow(10.0, decimals)
	var round_num = sgn*(int(num) + num_dec)
	return round_num
