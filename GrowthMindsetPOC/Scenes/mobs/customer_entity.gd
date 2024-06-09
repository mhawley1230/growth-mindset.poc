extends CharacterBody2D

class_name CustomerEntity


#@onready var movement_handler = $MovementHandler as MovementHandler
#@onready var mob_path = get_parent()
#@onready var progress: float
#@onready var available_plants

#func _ready():
	#available_plants = Global.plants_dict.keys()
	#name += "_" + str(Global.mobs_dict["spawned"]["mob_a"])
	#Global.mobs_dict["spawned"]["mob_a"] += 1
	#add_random_order_to_mob()
	#
	#
#func _physics_process(delta):
	#mob_path.set_progress(mob_path.get_progress() + movement_handler.movement_speed * delta)
	#
	#if Global.round_to_dec(mob_path.get_progress_ratio(), 2) > 0.50:
		#get_node("Sprite2D").flip_h = true
			#
	#if mob_path.get_progress_ratio() == 1:
		#queue_free()
	#
## TODO: Randomize multiple numbers of products within order, 
## 			i.e. 2 Potato vs 1 Tomato vs 2 Potato, 1 Tomato
#func add_random_order_to_mob():
	#var texture_paths = ["res://Assets/tomato_icon.png", "res://Assets/potato_icon.png"]	
	#var product_name = available_plants[randi_range(0, available_plants.size() - 1)]
	#var mob_name = name
	#var req = get_node("SellReq/Req")
	#for path in texture_paths:
		#if path.contains(product_name.to_lower()):
			#var texture = load(path)
			#req.set_texture(texture)
	#Global.orders_dict[mob_name] = {
				#"product": product_name,
				#"number": 1,
				#"order_completed": false
			#}

