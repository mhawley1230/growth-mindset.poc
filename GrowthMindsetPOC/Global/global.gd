extends Node

@export var speed = 200

var TILE_SIZE: int = 32
var orders_dict: Dictionary = {}
var mobs_dict = {
	"spawned": {
		"mob_a": 0
	}
}

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
	
func stop_queue():
	var path_holder = get_tree().root.get_node("SceneTree/GameLevel/PathSpawner")
	for mob_path in path_holder.get_children():
		if mob_path is Path2D:
			var path = mob_path.get_child(0)
			if path.get_progress_ratio() < 0.50:
				path.get_child(0).speed = 0
	path_holder.get_node("Timer").set_paused(true)
				
func continue_queue():
	print("continue called for:")
	var path_holder = get_tree().root.get_node("SceneTree/GameLevel/PathSpawner")
	for mob_path in path_holder.get_children():
		if mob_path is Path2D:
			var path = mob_path.get_child(0)
			for child in path.get_children():
				#if child.get_parent().get_progress_ratio() < 0.50:
				child.speed = Global.speed
					#print(child.speed)
	path_holder.get_node("Timer").set_paused(false)
