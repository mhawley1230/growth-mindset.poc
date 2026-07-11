class_name GameState
extends Node

enum GAME_STATUS { NOT_STARTED, ACTIVE, PAUSED, LOST }

var status: GAME_STATUS = GAME_STATUS.NOT_STARTED
var last_status: GAME_STATUS = GAME_STATUS.NOT_STARTED

# Inventory lives on the state so it is owned by the holder and cleared on reset.
# Shape: category -> { product: count }. GDScript can't express nested typed
# generics (e.g. Dictionary[String, Dictionary[String, int]]), so the outer
# dictionary's value type is the plain "Dictionary" below; each inner
# per-category dictionary is still declared as Dictionary[String, int] so its
# own keys/values stay statically typed.
var _seeds_inventory: Dictionary[String, int] = {}
var _plants_inventory: Dictionary[String, int] = {}
var inventory: Dictionary[String, Dictionary] = {
	"seeds": _seeds_inventory,
	"plants": _plants_inventory,
}

func initialize() -> void:
	pass
