extends Area2D

class_name SellArea

@onready var player = get_tree().root.get_node("SceneTree/GameLevel/Player")
@onready var mobs = get_tree().root.get_node("SceneTree/GameLevel/LevelSpawner/Stage/MobPath/MobSpawner")
	
func is_player_in_sell_area():
	var can_sell = false
	if get_overlapping_bodies().find(player):
		can_sell = true		
	return can_sell

func is_customer_in_sell_area():
	var can_sell = false
	var mob_name
	for mob in mobs.get_children():
		if Global.round_to_dec(mob.get_parent().get_parent().get_progress_ratio(), 2) == 0.50:
			mob_name = mob.name
			can_sell = true
	return { "mob_name": mob_name, "can_sell": can_sell }
