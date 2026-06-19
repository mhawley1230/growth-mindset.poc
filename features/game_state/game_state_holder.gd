class_name GameStateHolder
extends Node

var game_state: GameState

func setup() -> void:
	game_state = GameState.new()
	add_child(game_state)
	game_state.initialize()

func get_state() -> GameState:
	return game_state

func clear() -> void:
	if game_state:
		game_state.queue_free()
	game_state = null
