extends Node2D

@onready var stage: PackedScene = preload("res://Level/Stage.tscn")

func _ready():
	var temp_stage = stage.instantiate()
	add_child(temp_stage)	
		

