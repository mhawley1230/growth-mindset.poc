extends Node

@onready var cur = get_tree().root.get_node("GameLevel/UI/Cursor")
@onready var farm_plots = get_tree().root.get_node("GameLevel/UI/Farm/FarmPlotHolder")
@onready var plant_holder = get_tree().root.get_node("GameLevel/UI/Farm/PlantHolder")
@onready var tomato = preload("res://Level/Plants/tomato.tscn")
@onready var potato = preload("res://Level/Plants/potato.tscn")

var plants_dict: Dictionary = {"Tomato" : { "#_created": 0, "#_harvested": 0 }, "Potato": { "#_created": 0, "#_harvested": 0 } }
var positions_arr: Array
var cur_pos: Vector2
var offset = Global.offset
var temp

func _process(_delta):
	cur_pos = cur.get_position()

func create_plant(plant_index):
	var keys = plants_dict.keys()
	var selected_plant = keys[plant_index]
		
	match selected_plant:
		"Tomato":
			temp = tomato.instantiate()
		"Potato":
			temp = potato.instantiate()
			
	temp.name = selected_plant + "_" + str(plants_dict[selected_plant]["#_created"])
	plants_dict[selected_plant]["#_created"] += 1
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
	var harvested_plant
	
	for plant in plant_holder.get_children():
		var progress = plant.get_node("TextureProgressBar")
		if is_plant_at_position():
			if plant.position == cur_pos and progress.get_value() == progress.get_max():
				positions_arr.erase(plant.position)
				var name = plant.name.split("_")[0]
				plants_dict[name]["#_harvested"] += 1
				plant.queue_free()
