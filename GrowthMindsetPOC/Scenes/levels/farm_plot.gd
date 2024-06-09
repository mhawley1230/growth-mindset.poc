extends Area2D


func _on_body_entered(body):
	print(body)
	if body is Cursor:
		print("planting enabled")
		SignalBus.emit_is_within_farm_plot(true)


func _on_body_exited(body):
	print(body)
	if body is Cursor:
		print("planting disabled")
		SignalBus.emit_is_within_farm_plot(false)		
