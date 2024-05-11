extends Area2D

class_name SellArea

@onready var player = get_tree().root.get_node("SceneTree/GameLevel/Player")
#@onready var mobs = get_tree().root.get_node("SceneTree/GameLevel/LevelSpawner/Stage/MobPath/MobSpawner")
	
func is_player_in_sell_area():
	var can_sell = false
	if get_overlapping_bodies().find(player):
		print("player detected")
		can_sell = true
		
	return can_sell
