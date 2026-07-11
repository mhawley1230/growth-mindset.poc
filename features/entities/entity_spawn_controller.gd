class_name EntitySpawnController
extends Node

@export var _player_spawn_point: Marker2D

# PACKED SCENES
@export var player_packed_scene: PackedScene

var _game_controller: GameController
var _game_state_holder: GameStateHolder
var _inventory_controller: InventoryController
var _player: Player

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
