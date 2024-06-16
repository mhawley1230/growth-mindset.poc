class_name PlantEntity
extends Area2D

@onready var animation_player =  $AnimationPlayer as AnimationPlayer
@onready var texture_progress_bar = $TextureProgressBar as TextureProgressBar

var isHarvestable: bool = false


func _ready():
	animation_player.play("plant_growing")

func _process(_delta):
	
	if texture_progress_bar == null:
		return
	elif texture_progress_bar.value == 100:
		texture_progress_bar.visible = false
		isHarvestable = true
		texture_progress_bar.queue_free()


#func _on_area_exited(area):
	#if area is CursorEntity:
		#SignalBus.emit_on_area_contains_plant(false)


	
#@onready var cur = get_tree().root.get_node("SceneTree/GameLevel/Cursor")
#
#
#var positions_arr: Array
#var cur_pos: Vector2
#
#func _process(_delta):
	#var progress_bar = get_node("TextureProgressBar")
	#
	#if progress_bar.get_value() >= progress_bar.get_max():
		#progress_bar.set_visible(false)
	#
	#cur_pos = cur.get_position()

#func is_plant_at_position():
	#if positions_arr.is_empty() != true:
		#for position in positions_arr:
			#if position == cur_pos:
				#return true
	#return false
	
#func harvest():
	#for plant in plant_holder.get_children():
		#var harvested_plant = plant.name.split("_")[0]
		#var progress = plant.get_node("TextureProgressBar")
		#if is_plant_at_position():
			#if plant.position == cur_pos and progress.get_value() == progress.get_max():
				#if Global.plants_dict[harvested_plant]["current"]["plants_on_hand"] + 1 <= Global.plants_dict[harvested_plant]["current"]["target_inventory"]:
					#positions_arr.erase(plant.position)
					#Global.plants_dict[harvested_plant]["total"]["#_harvested"] += 1
					#Global.plants_dict[harvested_plant]["current"]["plants_on_hand"] += 1
					#plant.queue_free()
					
