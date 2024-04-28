extends Area2D

class_name SellArea

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	is_player_in_sell_area()
	
	
func is_player_in_sell_area():
	var can_sell = false
	if has_overlapping_bodies():
		can_sell = true
		
	return can_sell
