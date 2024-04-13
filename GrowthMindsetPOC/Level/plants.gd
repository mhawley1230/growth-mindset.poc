extends Node

@onready var cur = get_tree().root.get_node("GameLevel/UI/Cursor")
@onready var farm_plots = get_tree().root.get_node("GameLevel/UI/Farm/FarmPlotHolder")
@onready var plant_holder = get_tree().root.get_node("GameLevel/UI/Farm/PlantHolder")
var positions_arr: Array
var cur_pos: Vector2
var offset = Global.offset

func _process(_delta):
	cur_pos = cur.get_position()
	delete_plant()

func create_plant(plant):
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
	
func is_within_farm_plot():
	var result = false
	var cur_pos_x = int(cur_pos.x + offset.x)
	var cur_pos_y = int(cur_pos.y + offset.y)
	
	for plot in farm_plots.get_children():
		var min_x = plot.position.x
		var min_y = plot.position.y
		var plot_size = plot.get_dimensions()
		var max_x = min_x + plot_size.x
		var max_y = min_y + plot_size.y
		
		if min_x <= cur_pos_x and cur_pos_x <= max_x and min_y <= cur_pos_y and cur_pos_y <= max_y:
			result = true
	#
	return result
