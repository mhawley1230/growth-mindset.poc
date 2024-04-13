extends CharacterBody2D

@export var speed: int

@onready var mob_path: PathFollow2D
@onready var wait_point: Node2D
@onready var wait_point_pos: Vector2
@onready var progress: float
@onready var countdown: int = 3

func _ready():
	mob_path = get_tree().root.get_node("GameLevel/UI/LevelSpawner/Stage/MobPath")
	wait_point = get_tree().root.get_node("GameLevel/UI/LevelSpawner/Stage/MobPath/WaitPoint")
	
	
func _process(delta):
	mob_path.set_progress(mob_path.get_progress() + speed * delta)
	
	if wait_point is Node:
		wait_point_pos = wait_point.get_position()
	#print(get_position())
	
	
	if Global.round_to_dec(mob_path.get_progress_ratio(), 2) == 0.50:
		var current_speed = 0
		speed = current_speed
		await get_tree().create_timer(countdown).timeout
		speed = 100
		get_node("Sprite2D").flip_h = true
	 
	

