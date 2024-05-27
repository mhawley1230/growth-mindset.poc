extends Node

class_name Plant

@onready var cur = get_tree().root.get_node("SceneTree/GameLevel/Cursor")
@onready var farm_plots = get_tree().root.get_node("SceneTree/GameLevel/Farm/FarmPlotHolder")
@onready var plant_holder = get_tree().root.get_node("SceneTree/GameLevel/Farm/PlantHolder")
@onready var tomato: PackedScene = preload("res://Level/Plants/tomato.tscn")
@onready var potato: PackedScene = preload("res://Level/Plants/potato.tscn")


var positions_arr: Array
var cur_pos: Vector2

func _process(_delta):
	var progress_bar = get_node("TextureProgressBar")
	
	if progress_bar.get_value() >= progress_bar.get_max():
		progress_bar.set_visible(false)
	
	cur_pos = cur.get_position()

func create_plant(index):
	var keys = Global.plants_dict.keys()
	var selected_plant = keys[index]
	var temp: Sprite2D
	
	if Global.plants_dict[selected_plant]["current"]["seeds"] > 0:
		match selected_plant:
			"Tomato": 
				temp  = tomato.instantiate()
			"Potato":
				temp = potato.instantiate()
			
		temp.name = selected_plant + "_" + str(Global.plants_dict[selected_plant]["total"]["#_created"])
		Global.plants_dict[selected_plant]["total"]["#_created"] += 1
		Global.plants_dict[selected_plant]["current"]["seeds"] -= 1
		plant_holder.add_child(temp)
		temp.set_position(cur_pos)
		positions_arr.append(temp.position)
		temp.get_node("AnimationPlayer").play("grow_anim")

func is_plant_at_position():
	if positions_arr.is_empty() != true:
		for position in positions_arr:
			if position == cur_pos:
				return true
	return false
	
func harvest():
	for plant in plant_holder.get_children():
		var harvested_plant = plant.name.split("_")[0]
		var progress = plant.get_node("TextureProgressBar")
		if is_plant_at_position():
			if plant.position == cur_pos and progress.get_value() == progress.get_max():
				if Global.plants_dict[harvested_plant]["current"]["plants_on_hand"] + 1 <= Global.plants_dict[harvested_plant]["current"]["target_inventory"]:
					positions_arr.erase(plant.position)
					Global.plants_dict[harvested_plant]["total"]["#_harvested"] += 1
					Global.plants_dict[harvested_plant]["current"]["plants_on_hand"] += 1
					plant.queue_free()
					
