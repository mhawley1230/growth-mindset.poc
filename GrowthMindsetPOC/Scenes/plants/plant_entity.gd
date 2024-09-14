class_name PlantEntity
extends Area2D


@onready var animation_player =  $AnimationPlayer as AnimationPlayer
@onready var texture_progress_bar = $TextureProgressBar as TextureProgressBar

var isHarvestable: bool = false
var num_created: int = 0
var plant_name: String = ""


func _ready():
	plant_name = self.name.split("Entity")[0]
	update_entity_name()
	
	# Start growing
	animation_player.play("plant_growing")


func _process(_delta):
	if texture_progress_bar == null:
		return
	elif texture_progress_bar.value == 100:
		texture_progress_bar.visible = false
		isHarvestable = true
		texture_progress_bar.queue_free()


func update_entity_name() -> void:
	self.name = plant_name + "_" + str(num_created)
