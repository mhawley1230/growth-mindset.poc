class_name Level
extends Node2D

#region seeds
@export var tomato_seeds_starting: int
@export var potato_seeds_starting: int
@export var tomatoes_starting: int
@export var potatoes_starting: int


func _ready() -> void:
	Inventory.create_inventory("seeds", "tomato", tomato_seeds_starting)
	Inventory.create_inventory("seeds", "potato", potato_seeds_starting)
	Inventory.create_inventory("plants", "tomato", tomatoes_starting)
	Inventory.create_inventory("plants", "potato", potatoes_starting)
