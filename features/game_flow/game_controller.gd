class_name GameController
extends Node

signal on_game_loss

var _inventory_controller: InventoryController
var _game_state_holder: GameStateHolder
var _entity_spawn_controller: EntitySpawnController

var state: GameState:
	get: return _game_state_holder.game_state

func bind_services(inventory_controller: InventoryController,\
		entity_spawn_controller: EntitySpawnController,\
		game_state_holder: GameStateHolder\
	) -> void:
		_inventory_controller = inventory_controller
		_entity_spawn_controller = entity_spawn_controller
		_game_state_holder = game_state_holder

func start() -> void:
	_inventory_controller.reset()
	state.status = GameState.GAME_STATUS.ACTIVE

func toggle_pause() -> void:
	if state.status == GameState.GAME_STATUS.PAUSED:
		state.status = state.last_status
	else:
		state.last_status = state.status
		state.status = GameState.GAME_STATUS.PAUSED

func _process(_delta: float) -> void:
	if state:
		if Input.is_action_just_pressed("pause"):
			toggle_pause()
		
		if state.status == GameState.GAME_STATUS.ACTIVE:
			# start timer, accept input
			pass
		elif state.status == GameState.GAME_STATUS.LOST:
			on_game_loss.emit()
