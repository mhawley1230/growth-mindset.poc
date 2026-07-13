class_name PlantEntity
extends Area2D

enum Type { TOMATO, POTATO }

@export var texture_progress_bar: TextureProgressBar
@export var animation_player: AnimationPlayer

var isHarvestable: bool = false


## TODO: StateManager for growing states, 3-4 total states, 2-3 player/automated actions to advance state w/ animations
func _ready() -> void:
	set_meta("plant_name", name)
	animation_player.play("plant_growing")

func _process(_delta: float) -> void:
	if texture_progress_bar == null:
		return
	elif texture_progress_bar.value == 100:
		texture_progress_bar.visible = false
		isHarvestable = true
		texture_progress_bar.queue_free()
