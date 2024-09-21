class_name PlayerManager
extends Node


func _ready():
	SignalBus.on_player_ready.connect(on_player_ready)


func on_player_ready(_player: PlayerEntity) -> void:
	## After player loads, do something
	pass
