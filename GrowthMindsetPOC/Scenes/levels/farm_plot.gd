extends Area2D


func _on_area_entered(area):
	print(str(area.name) + " entered")
	if area is CursorEntity:
		SignalBus.emit_is_within_farm_plot(true)


func _on_area_exited(area):
	print(str(area.name) + " exited")
	if area is CursorEntity:
		SignalBus.emit_is_within_farm_plot(false)
