extends Node2D
@onready var path = preload("res://Level/path.tscn")

func _on_timer_timeout():
	var temp = path.instantiate()
	add_child(temp)
