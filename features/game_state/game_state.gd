class_name GameState
extends Node

enum GAME_STATUS { NOT_STARTED, ACTIVE, PAUSED, LOST }

var status: GAME_STATUS = GAME_STATUS.NOT_STARTED
var last_status: GAME_STATUS = GAME_STATUS.NOT_STARTED

func initialize() -> void:
	pass
