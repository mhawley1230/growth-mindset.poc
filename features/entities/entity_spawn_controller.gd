class_name EntitySpawnController
extends Node

@export var _player_spawn_point: Marker2D

# PACKED SCENES
@export var player_packed_scene: PackedScene

# CUSTOMER SPAWNING
# Level-owned customer spawn authority (see NOTES.txt "DECISION: customer
# behavior"): EntitySpawnController decides *which* customer spawns next;
# path_controller (the level's Path2D) owns spawn timing and moving customers
# along its curve. Both wired in the level scene, so this is a no-op until
# path_controller is assigned.
@export var path_controller: PathController
@export var customers_array: Array[CustomerEntityData] = []

var _game_controller: GameController
var _game_state_holder: GameStateHolder
var _inventory_controller: InventoryController
var _player: Player

func _ready() -> void:
	if path_controller:
		path_controller.spawn_ready.connect(_on_spawn_ready)

func bind_services(game_controller: GameController,
		game_state_holder: GameStateHolder,
		inventory_controller: InventoryController,
	) -> void:
	_game_controller = game_controller
	_game_state_holder = game_state_holder
	_inventory_controller = inventory_controller

func instantiate_player(available_plants: Array[PlantData] = []) -> void:
	if _player:
		return
	_player = player_packed_scene.instantiate() as Player
	add_child(_player)
	if _player_spawn_point:
		_player.global_position = _player_spawn_point.global_position
	_player.bind_services(_inventory_controller, available_plants)

## Lets LevelContext pull the spawned player's LevelOverlay once it exists,
## since the overlay itself is nested under the player's camera/HUD, not
## something LevelContext ever builds or owns directly.
func get_player() -> Player:
	return _player

## Fired by path_controller's spawn Timer: picks a random entry from
## customers_array, instantiates its scene, and hands the instance to
## path_controller to place on a fresh PathFollow2D.
func _on_spawn_ready() -> void:
	if customers_array.is_empty() or path_controller == null:
		return
	var customer_data: CustomerEntityData = customers_array[randi() % customers_array.size()]
	if customer_data == null or customer_data.scene == null:
		return
	var customer: CharacterBody2D = customer_data.scene.instantiate() as CharacterBody2D
	if customer == null:
		return
	path_controller.add_customer(customer)
