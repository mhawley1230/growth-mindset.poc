class_name PlantEntity
extends Node2D

@export var plant: Plant

@onready var texture_progress_bar: TextureProgressBar
@onready var animation_player: AnimationPlayer

var isHarvestable: bool = false

## TODO: StateManager for growing states, 3-4 total states, 2-3 player/automated 
##     actions to advance state w/ animations
func _ready():
	var instance: Node = plant.scene.instantiate()
	add_child(instance)
	texture_progress_bar = get_node("Node2D/TextureProgressBar")
	animation_player = get_node("Node2D/AnimationPlayer")
	
	animation_player.play("plant_growing")

func _process(_delta):
	if texture_progress_bar == null:
		return
	elif texture_progress_bar.value == 100:
		texture_progress_bar.visible = false
		isHarvestable = true
		texture_progress_bar.queue_free()
