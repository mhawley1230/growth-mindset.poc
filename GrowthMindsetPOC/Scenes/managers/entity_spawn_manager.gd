class_name EntitySpawnManager 
extends Node

#region Player Region
@export_category("Player")
@export var player_spawn_point: Marker2D = null
@export var player_packed_scene: PackedScene = null

var player_spawned: bool = false
#endregion

#region Customer Region
@export_category("Customer")
#@export var enemy_spawn_timer_min: float = 0.1
#@export var enemy_spawn_timer_max: float = 4.0
@export var spawn_points: Array[Marker2D] = []
@export var customer_entity_scene: PackedScene = null
#@export var max_customers_spawned: int = 3

#@onready var customer_spawn_timer = $CustomerSpawnTimer as Timer

#var customer_count: int = 0
#endregion


func _ready():
	if player_spawned == false:
		spawn_player()
	else:	
		pass
	
	spawn_customer()


func spawn_player() -> void:
	var new_player_entity: PlayerEntity = player_packed_scene.instantiate()
	var entity_container: Node2D = NodeExtensions.get_entity_container()
	
	if entity_container == null:
		return
	
	entity_container.add_child(new_player_entity)
	new_player_entity.position = player_spawn_point.position


func spawn_customer() -> void:
	#if customer_count >= max_customers_spawned:
		#return
	
	var new_customer_entity: CustomerEntity = customer_entity_scene.instantiate()
	var entity_container: Node2D = NodeExtensions.get_entity_container()
	#
	if entity_container == null:
		return
	#
	entity_container.add_child(new_customer_entity)
	new_customer_entity.position = spawn_points[0].position
	
	
	#customer_spawn_timer.start(NodeExtensions.get_random_time(enemy_spawn_timer_min \
	  #,enemy_spawn_timer_max))
	#
	#customer_count += 1

#
#func _on_customer_spawn_timer_timeout():
	#spawn_customer()
