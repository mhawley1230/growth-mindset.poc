class_name LevelContext
extends Node

@onready var _entity_spawn_controller: EntitySpawnController = $EntitySpawnController

@export var _level_overlay_packed: PackedScene
@export var available_plants: Array[PlantData]

var _game_state_holder: GameStateHolder
var _game_controller: GameController
var _inventory_controller: InventoryController

func build_services() -> void:
	pass

func bind_services(game_state_holder: GameStateHolder,\
	game_controller: GameController,\
	inventory_controller: InventoryController,
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
		_entity_spawn_controller.instantiate_player(available_plants)
		print("player loaded")
	_seed_starting_inventory()
	if _level_overlay_packed:
		var level_overlay: LevelOverlay = _level_overlay_packed.instantiate()
		if _entity_spawn_controller.get_player():
			var player: Player = _entity_spawn_controller.get_player()
			if player.has_node("Camera2D"):
				var player_cam: Camera2D = player.get_node("Camera2D")
				player_cam.add_child(level_overlay)
		level_overlay.initialize(_inventory_controller)

## TODO: replace with level-configured starting products (see the commented
## @export arrays that previously drove starting inventory). Placeholder so the
## inventory + planting/harvesting slice is exercisable.
func _seed_starting_inventory() -> void:
	_inventory_controller.add("plants", "tomato", 0)
	_inventory_controller.add("plants", "potato", 0)
	_inventory_controller.add("seeds", "tomato", 5)
	_inventory_controller.add("seeds", "potato", 5)
	print("Inventory loaded")
