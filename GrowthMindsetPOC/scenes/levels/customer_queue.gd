class_name CustomerQueue
extends Node2D

func _on_wait_area_body_entered(body):
	if body.name == "CustomerBody":
		print(body)
		SignalBus.emit_on_customer_wait_area_entered()
