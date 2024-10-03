class_name RoundTimer_UI
extends Control

@onready var timer_label = $TimerLabel as Label

var round_timer: Timer = null


func _ready() -> void:
	SignalBus.on_game_state_manager_ready.connect(on_game_state_manager_ready)


func _process(_delta) -> void:
	if round_timer == null:
		return
	
	set_timer_label_text()


func set_timer_label_text() -> void:
	timer_label.text = str(roundf(round_timer.time_left))


func on_game_state_manager_ready(game_state_manager: GameStateManager) -> void:
	round_timer = game_state_manager.state_timer
