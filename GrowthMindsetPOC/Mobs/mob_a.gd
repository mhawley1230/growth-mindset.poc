extends CharacterBody2D


@export var speed: int = 300

@onready var customers = get_parent()
@onready var mob_spawner = preload("res://Level/mob_spawner.gd")
@onready var plants_scripts = preload("res://Level/plants.gd")
@onready var player_scripts = preload("res://Player/player.gd")
@onready var mob_path: PathFollow2D
@onready var wait_point: Node2D
@onready var wait_point_pos: Vector2
@onready var progress: float
@onready var countdown: int = 3
@onready var plants
@onready var available_plants

var player
var mob_order
@export var has_traded: bool = false

func _ready():
	player = player_scripts.new()
	mob_path = get_tree().root.get_node("SceneTree/GameLevel/LevelSpawner/Stage/MobPath")
	plants = plants_scripts.new()
	available_plants = plants.get_plants_dict().keys()
	mob_order = add_random_order_to_mob()
	
	
func _process(delta):
	mob_path.set_progress(mob_path.get_progress() + speed * delta)
	
	if Global.round_to_dec(mob_path.get_progress_ratio(), 2) == 0.50:
		speed = 0
		
		if Global.orders_dict[name]["order_completed"]:
			speed = 200
			get_node("Sprite2D").flip_h = true
	
# TODO: Randomize multiple numbers of products within order, 
# 			i.e. 2 Potato vs 1 Tomato vs 2 Potato, 1 Tomato
func add_random_order_to_mob():
	var texture_paths = ["res://Assets/tomato_icon.png", "res://Assets/potato_icon.png"]	
	var product_name = available_plants[randi_range(0, available_plants.size() - 1)]
	var mob_name = name
	var req = get_node("SellReq/Req")
	for path in texture_paths:
		if path.contains(product_name.to_lower()):
			var texture = load(path)
			req.set_texture(texture)
	Global.orders_dict = {
		str(mob_name): 
			{
				"product": product_name,
				"number": 1,
				"order_completed": false
			}
	}
	
func get_order():
	return Global.orders_dict[name]

