extends Area2D

@export var plant: Plant


func _ready() -> void:
	var instance = plant.scene.instantiate()
	add_child(instance)
