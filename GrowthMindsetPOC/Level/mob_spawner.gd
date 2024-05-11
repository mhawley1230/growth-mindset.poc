extends Node2D

@onready var mob_arr: Array[CharacterBody2D]
@onready var mob_a: PackedScene = preload("res://Mobs/MobA.tscn")


@onready var temp_mob_a: CharacterBody2D
@onready var path: PathFollow2D
var num_created = 0

func _ready():
	path = get_parent()
	temp_mob_a = mob_a.instantiate()
	temp_mob_a.name += "_" + str(num_created)
	num_created += 1
	
	add_child(temp_mob_a)
	mob_arr.append(temp_mob_a)
	
	
func _physics_process(_delta):
	for mob in mob_arr:
		if path is Node && path.get_progress_ratio() == 1 && mob_arr.size() > 0:
			mob_arr.erase(mob)
			queue_free()
