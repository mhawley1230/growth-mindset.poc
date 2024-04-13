extends Node

@onready var cur = get_tree().root.get_node("GameLevel/UI/Cursor")
@onready var farm_plot = get_tree().root.get_node("GameLevel/UI/Farm/FarmPlotHolder")
var positions_arr: Array
var cur_pos: Vector2

func _process(_delta):
	cur_pos = cur.get_position()

func create_plant(plant):
	var plant_holder = get_tree().root.get_node("GameLevel/UI/Farm/PlantHolder")
	var temp_plant = plant.instantiate()
	
	temp_plant.name = str(plant) + str(plant_holder.get_child_count())
	plant_holder.add_child(temp_plant)
	temp_plant.set_position(cur_pos)
	positions_arr.append(temp_plant.position)
	temp_plant.get_node("AnimationPlayer").play("grow_anim")

func is_plant_at_position():
	if positions_arr.is_empty() != true:
		for position in positions_arr:
			if position == cur_pos:
				return true
	return false
	
#func is_within_farm_plot():
	#for plot in farm_plot.get_children():
		#print(plot.get_position())
