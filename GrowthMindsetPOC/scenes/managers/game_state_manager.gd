class_name GameStateManager
extends Node


@onready var state_timer = $StateTimer as Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	#state_timer.timeout.connect()
	SignalBus.emit_on_game_state_manager_ready(self)


func _on_state_timer_timeout():
	pass # Replace with function body.
