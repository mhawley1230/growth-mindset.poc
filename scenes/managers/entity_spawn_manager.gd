extends Node

@export var player_spawn_point: Marker2D = null

#@export var path_spawn_point: Array[Marker2D] = []
#@export var path_packed_scene: PackedScene = null

var player_spawned: bool = false


func _ready():
	if player_spawned == true:
		return
	
	spawn_player()
	#spawn_path()

func spawn_player() -> void:
	var instance: CharacterBody2D = Refs.player_scene.instantiate()
	var entity_container: Node = NodeExtensions.get_entity_container()
	
	if entity_container == null:
		return
	
	entity_container.add_child(instance)
	instance.position = player_spawn_point.position

#func spawn_path() -> void:
	#var entity_container: Node = NodeExtensions.get_entity_container()
	#
	#if entity_container == null:
		#return
	#
	#var instance: Path2D = path_packed_scene.instantiate()
	#entity_container.add_child(instance)
	#instance.global_position = path_spawn_point[0].position
