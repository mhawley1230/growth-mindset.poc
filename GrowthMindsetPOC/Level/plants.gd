extends Node

@onready var cur = get_tree().root.get_node("SceneTree/GameLevel/Cursor")
@onready var farm_plots = get_tree().root.get_node("SceneTree/GameLevel/Farm/FarmPlotHolder")
@onready var plant_holder = get_tree().root.get_node("SceneTree/GameLevel/Farm/PlantHolder")
@onready var tomato = preload("res://Level/Plants/tomato.tscn")
@onready var potato = preload("res://Level/Plants/potato.tscn")

@onready var plants_ui = get_tree().root.get_node("SceneTree/UI/PlantsUI/MarginContainer/GridContainer")
@onready var seeds_ui = get_tree().root.get_node("SceneTree/UI/SeedsUI/MarginContainer/GridContainer")

var plants_dict: Dictionary = \
{ \
	"Tomato" : { \
		"total": { \
			"#_created": 0, "#_harvested": 0 \
			}, \
		"current": { \
			"seeds": 4, "plant_on_hand": 0, "target_inventory": 10 \
			} \
	}, \
	"Potato": { \
		"total": { \
			"#_created": 0, "#_harvested": 0 \
			}, \
		"current": { \
			"seeds": 4, "plant_on_hand": 0, "target_inventory": 10 \
			} \
	} \
}
var positions_arr: Array
var cur_pos: Vector2
var temp

func _process(_delta):
	cur_pos = cur.get_position()
	
	for element in plants_ui.get_children():
		if element.name.contains("Label"):
			var plant = element.name.split("L")[0]
			var held = plants_dict[plant]["current"]["plant_on_hand"]
			var max_held = plants_dict[plant]["current"]["target_inventory"]
			element.text = str(held) + " / " + str(max_held)
			
	for element in seeds_ui.get_children():
		if element.name.contains("Label"):
			var plant = element.name.split("Seeds")[0]
			var held = plants_dict[plant]["current"]["seeds"]
			var max_held = plants_dict[plant]["current"]["target_inventory"]
			element.text = str(held) + " / " + str(max_held)

func create_plant(plant_index):
	var keys = plants_dict.keys()
	var selected_plant = keys[plant_index]
	
	if plants_dict[selected_plant]["current"]["seeds"] > 0:
		match selected_plant:
			"Tomato":
				temp = tomato.instantiate()
			"Potato":
				temp = potato.instantiate()
			
		temp.name = selected_plant + "_" + str(plants_dict[selected_plant]["total"]["#_created"])
		plants_dict[selected_plant]["total"]["#_created"] += 1
		plants_dict[selected_plant]["current"]["seeds"] -= 1
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
				if plants_dict[harvested_plant]["current"]["plant_on_hand"] + 1 <= plants_dict[harvested_plant]["current"]["target_inventory"]:
					positions_arr.erase(plant.position)
					plants_dict[harvested_plant]["total"]["#_harvested"] += 1
					plants_dict[harvested_plant]["current"]["plant_on_hand"] += 1
					plant.queue_free()
					
func get_plants_dict():
	return plants_dict
