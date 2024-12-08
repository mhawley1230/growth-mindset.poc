class_name CustomerQueue
extends Node2D


func _on_wait_area_body_entered(body):
	if body.is_in_group("customer"):
		SignalBus.emit_on_customer_wait_area_entered(body)
