class_name CustomerManager
extends Node


func _ready() -> void:
	SignalBus.on_customer_ready.connect(on_customer_ready)


func on_customer_ready(_customer: CustomerEntity) -> void:
	# after customer spawns, do something
	pass
