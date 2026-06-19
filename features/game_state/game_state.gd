class_name GameState
extends Node

enum GAME_STATUS { NOT_STARTED, ACTIVE, PAUSED, LOST }

var status: GAME_STATUS = GAME_STATUS.NOT_STARTED
var last_status: GAME_STATUS = GAME_STATUS.NOT_STARTED

# Inventory lives on the state so it is owned by the holder and cleared on reset.
# Shape: { "seeds": { <product>: int }, "plants": { <product>: int } }
var inventory: Dictionary = { "seeds": {}, "plants": {} }

func initialize() -> void:
	pass
