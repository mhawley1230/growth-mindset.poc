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
		_entity_spawn_controller.bind_services(
			_game_controller, _game_state_holder, _inventory_controller)
	_game_controller.bind_services(
		_inventory_controller, _entity_spawn_controller, _game_state_holder)
	_game_controller.start()
	if _entity_spawn_controller:
		_entity_spawn_controller.instantiate_player()
	_seed_starting_inventory()
	print("level initialized")

## TODO: replace with level-configured starting products (see the commented
## @export arrays that previously drove starting inventory). Placeholder so the
## inventory + planting/harvesting slice is exercisable.
func _seed_starting_inventory() -> void:
	_inventory_controller.add("seeds", "tomato", 5)
	_inventory_controller.add("seeds", "potato", 5)
