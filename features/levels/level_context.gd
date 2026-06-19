class_name LevelContext
extends Node

@onready var _entity_spawn_controller: EntitySpawnController = $EntitySpawnController

var _game_state_holder: GameStateHolder
var _game_controller: GameController
var _inventory_controller: InventoryController

func build_services() -> void:
	pass

func bind_services(game_state_holder: GameStateHolder,\
	game_controller: GameController,\
	inventory_controller: InventoryController,\
	) -> void:
	_game_state_holder = game_state_holder
	_game_controller = game_controller
	_inventory_controller = inventory_controller

func initialize() -> void:
	# The spawn controller is level-scoped, so GameController's binding completes
	# here, once the level's EntitySpawnController exists.
	if _entity_spawn_controller:
		_entity_spawn_controller.bind_services(_game_controller, _game_state_holder)
	_game_controller.bind_services(
		_inventory_controller, _entity_spawn_controller, _game_state_holder)
	_game_controller.start()
	print("level initialized")

# Phase 2 (step 9): have the spawn controller instantiate the player here, e.g.
#	_entity_spawn_controller.instantiate_player()
#
# Phase 2 (step 11): seed starting inventory through _inventory_controller from
# level-configured products instead of the old global InventoryManager.
