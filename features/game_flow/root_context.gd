class_name RootContext
extends Node

signal request_start_game # move to menu script (PanelController)
 
@export var game_scene_packed: PackedScene

var _game_state_holder: GameStateHolder

var current_scene: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_services()
	request_start_game.connect(handle_request_start_game)
	request_start_game.emit()

func _initialize() -> void:
	pass

func build_services() -> void:
	_game_state_holder = GameStateHolder.new()
	add_child(_game_state_holder)
	_game_state_holder.setup()

func bind_services() -> void:
	pass

func handle_request_start_game() -> void:
	if current_scene:
		current_scene.queue_free()
	current_scene = game_scene_packed.instantiate()
	add_child(current_scene)
	
	var level_select_scene: GameContext = current_scene as GameContext
	if level_select_scene:
		level_select_scene.build_services()
		level_select_scene.bind_services(_game_state_holder)
		level_select_scene.on_game_loss.connect(handle_loss)
		level_select_scene.initialize()

func handle_loss() -> void:
	print("game over")
	# TODO (Phase 4): swap current_scene to the menu scene via a MenuContext.
