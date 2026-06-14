class_name EntitySpawnController
extends Node

@export var _player_spawn_point: Marker2D

# PACKED SCENES
@export var player_packed_scene: PackedScene

var _game_controller: GameController
var _game_state_holder: GameStateHolder
var _player: Player

func bind_services(game_controller: GameController,
		game_state_holder: GameStateHolder,
	) -> void:
	_game_controller = game_controller
	_game_state_holder = game_state_holder
	
func instantiate_player() -> void:
	_player = player_packed_scene.instantiate_player_spawn_point()
	print(_player_spawn_point.global_position)
	
