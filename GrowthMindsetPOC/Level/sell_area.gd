extends Area2D

class_name SellArea

@onready var player = preload("res://Player/Player.tscn")

func is_player_in_sell_area():
	var bodies_in_area = get_overlapping_bodies()
	for body in bodies_in_area:
		if body is Player:
			return true
	return false
				
func is_customer_in_sell_area():
	var bodies_in_area = get_overlapping_bodies()
	for body in bodies_in_area:
		if body is Mob:
			return true
	return false
				
func get_customer_name_in_sell_area():
	var bodies_in_area = get_overlapping_bodies()
	for body in bodies_in_area:
		if body is Mob:
			return body.name
