class_name GameContext
extends Node

signal request_level_load
signal on_game_loss

# LOCAL STRUCTURE
@export var game_level: PackedScene

var _game_state_holder: GameStateHolder
var _game_controller: GameController
var _inventory_controller: InventoryController
# var _sfx: SFXPlayer
# var _music: MusicPlayer

var current_level: Node

func build_services() -> void:
	_inventory_controller = InventoryController.new()
	add_child(_inventory_controller)
	_game_controller = GameController.new()
	add_child(_game_controller)

func bind_services(gsh: GameStateHolder) -> void:
	_game_state_holder = gsh
	_inventory_controller.bind_services(_game_state_holder)
	_game_controller.on_game_loss.connect(_on_game_loss)

func initialize() -> void:
	request_level_load.connect(handle_level_select)
	request_level_load.emit()

func handle_level_select() -> void:
	if current_level:
		current_level.queue_free()
	current_level = game_level.instantiate()
	add_child(current_level)

	var level: LevelContext = current_level as LevelContext
	if level:
		level.build_services()
		level.bind_services(
			_game_state_holder,
			_game_controller,
			_inventory_controller
		)
		level.initialize()

func _on_game_loss() -> void:
	on_game_loss.emit()
