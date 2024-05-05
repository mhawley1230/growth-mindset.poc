extends CharacterBody2D


@export var speed: int

@onready var mob_spawner = preload("res://Level/mob_spawner.gd")
#@onready var mob: CharacterBody2D
@onready var mob_path: PathFollow2D
@onready var wait_point: Node2D
@onready var wait_point_pos: Vector2
@onready var progress: float
@onready var countdown: int = 3
@onready var plants_scripts = preload("res://Level/plants.gd")
@onready var plants

func _ready():
	#mob = Mob.new()
	mob_path = get_tree().root.get_node("SceneTree/GameLevel/LevelSpawner/Stage/MobPath")
	plants = plants_scripts.new()
	add_random_requirement_to_mob()
	
	
func _process(delta):
	mob_path.set_progress(mob_path.get_progress() + speed * delta)
	
	if Global.round_to_dec(mob_path.get_progress_ratio(), 2) == 0.50:
		var current_speed = 0
		speed = current_speed
		#mob.is_transaction_complete()
		await get_tree().create_timer(countdown).timeout
		speed = 100
		get_node("Sprite2D").flip_h = true
		
func add_random_requirement_to_mob():
	var texture_paths = ["res://Assets/tomato_icon.png", "res://Assets/potato_icon.png"]
	var available_plants = plants.get_plants_dict().keys()
	var mob_order = available_plants[randi_range(0, available_plants.size()-1)]
	var req = get_node("SellReq/Req")
	
	for path in texture_paths:
		if path.contains(mob_order.to_lower()):
			var texture = load(path)
			req.set_texture(texture)
	
	return mob_order
