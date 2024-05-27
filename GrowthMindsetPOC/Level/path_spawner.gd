class_name PathSpawner
extends Node2D

@onready var path = preload("res://Level/path.tscn")

func _on_timer_timeout():
	var temp = path.instantiate()
	add_child(temp)

func stop_queue():
	for mob_path in self.get_children():
		if mob_path is Path2D:
			var path_progress = mob_path.get_child(0)
			if path_progress.get_progress_ratio() <= 0.50:
				path_progress.get_child(0).movement_handler.movement_speed = 0
	self.get_node("Timer").set_paused(true)
				#
#func continue_queue():
	#print("continue called for:")
	#for mob_path in self.get_children():
		#if mob_path is Path2D:
			#var path = mob_path.get_child(0)
			#for child in path.get_children():
				#child.speed = 400
	#self.get_node("Timer").set_paused(false)

func _on_sell_area_body_entered(_body):
	stop_queue()

#func _on_sell_area_body_exited(body):
	#continue_queue()

