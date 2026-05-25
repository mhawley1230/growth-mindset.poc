class_name GameContext
extends Node

signal request_level_load

# LOCAL STRUCTURE
@export var overlay: GameOverlay
@export var game_level: PackedScene
## TODO: abstract to level select scene w/ passthrough 

var _game_state_holder: GameStateHolder
# var _sfx: SFXPlayer
# var _music: MusicPlayer

var current_level: Node

func initialize() -> void:
	request_level_load.connect(handle_level_select)
	request_level_load.emit()

func build_services() -> void:
	pass

func bind_services(gsh: GameStateHolder) -> void:
	_game_state_holder = gsh

func handle_level_select() -> void:
	print("select level signal received")
	if current_level:
		current_level.queue_free()
	current_level = game_level.instantiate()
	add_child(current_level)
	
	#var _selected_level: LevelContext = current_level as LevelContext
