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
@export var enemy_spawn_timer_min: float = 0.1
@export var enemy_spawn_timer_max: float = 4.0
@export var spawn_points: Array[Marker2D] = []
@export var customer_entity_scene: PackedScene = null
@export var max_customers_spawned: int = 3

@onready var customer_spawn_timer = $CustomerSpawnTimer as Timer

var enemy_count: int = 0
#endregion


func _ready():
	if player_spawned == false:
		spawn_player()
	else:
		pass
	
	#customer_spawn_timer.timeout.connect(on_customer_spawn)
	#customer_spawn_timer.start()


func spawn_player() -> void:
	var new_player_entity: PlayerEntity = player_packed_scene.instantiate()
	var entity_container: Node2D = NodeExtensions.get_entity_container()
	
	if entity_container == null:
		return
	
	entity_container.add_child(new_player_entity)
	new_player_entity.position = player_spawn_point.position


#func on_customer_spawn() -> void:
	#if enemy_count >= max_customers_spawned:
		#return
	#
	#var new_customer: CustomerEntity = customer_entity_scene.instantiate()
	#var entity_container: Node2D = NodeExtensions.get_entity_container()
	#
	#if entity_container == null:
		#return
	#
	#spawn_points.shuffle()
	#
	##var chosen_spawn_point: Marker2D = spawn_points.pick_random()
	#
	#if entity_container == null:
		#return
	#
	#entity_container.add_child(new_customer)
#a	new_customer.position = chosen_spawn_point.position
	#
	#customer_spawn_timer.start(NodeExtensions.get_random_time(enemy_spawn_timer_min \
	  #,enemy_spawn_timer_max))
	#
	#enemy_count += 1
