class_name Plant
extends Area2D

@onready var texture_progress_bar := $TextureProgressBar 
@onready var animation_player := $AnimationPlayer

var isHarvestable: bool = false

## TODO: StateManager for growing states, 3-4 total states, 2-3 player/automated actions to advance state w/ animations
func _ready():
	animation_player.play("plant_growing")

func _process(_delta):
	if texture_progress_bar == null:
		return
	elif texture_progress_bar.value == 100:
		texture_progress_bar.visible = false
		isHarvestable = true
		texture_progress_bar.queue_free()
