extends Node2D

#class_name Mob

@onready var mob_arr: Array[CharacterBody2D]
@onready var mob_a: PackedScene = preload("res://Mobs/MobA.tscn")


@onready var temp_mob_a: CharacterBody2D
@onready var path: PathFollow2D

func _ready():
	path = get_parent()
	temp_mob_a = mob_a.instantiate()

	add_child(temp_mob_a)
	mob_arr.append(temp_mob_a)
	
	
func _physics_process(_delta):
	var childCount = mob_arr.size()
	#print(mob_arr)
	
	for mob in mob_arr:
		if path is Node && path.get_progress_ratio() == 1 && childCount > 0:
			mob_arr.erase(mob)
			queue_free()

	

#func is_transaction_complete():
	#var req = mob_arr[0].get_node("SellReq").get_child(0).name
	#print(mob_arr)
		#return true
	#return false
