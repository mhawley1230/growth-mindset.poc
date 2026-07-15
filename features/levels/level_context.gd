class_name LevelContext
extends Node

@onready var _entity_spawn_controller: EntitySpawnController = $EntitySpawnController
@onready var _trade_area: TradeArea = $CustomerArea/TradeArea
@onready var _path_controller: PathController = $CustomerArea/Path2D

@export var _level_overlay_packed: PackedScene
@export var available_plants: Array[PlantData]

var _game_state_holder: GameStateHolder
var _game_controller: GameController
var _inventory_controller: InventoryController

# The customer currently occupying the trade area, tracked so a successful
# trade can clear that specific customer's order bubble.
var _current_trade_customer: Node = null

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
	_wire_trade_area()
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

## Bridges TradeArea's local signals into the player's ActionComponent (see
## NOTES.txt "DECISION: customer behavior" - cross-entity events are wired by
## the level, not a global SignalBus). No-op if the level has no trade area or
## the player hasn't spawned yet.
func _wire_trade_area() -> void:
	var player: Player = _entity_spawn_controller.get_player() if _entity_spawn_controller else null
	if _trade_area == null or player == null:
		return
	_trade_area.player_entered.connect(_on_trade_area_player_entered)
	_trade_area.customer_entered.connect(_on_trade_area_customer_entered)
	_trade_area.trade_area_exited.connect(_on_trade_area_exited)
	player.trading_component.trade_completed.connect(_on_trade_completed)
	if _path_controller:
		player.trading_component.trade_completed.connect(_path_controller.on_trade_completed)

func _on_trade_area_player_entered() -> void:
	var player: Player = _entity_spawn_controller.get_player()
	player.action_component.set_trading_enabled(true)

## customer is whatever body entered the TradeArea as a validated CustomerEntity
## (the FrogEntity instance); its order comes from CustomerEntity.get_order().
func _on_trade_area_customer_entered(customer: Node) -> void:
	var player: Player = _entity_spawn_controller.get_player()
	var customer_entity: CustomerEntity = customer as CustomerEntity
	_current_trade_customer = customer
	player.action_component.set_customer_in_trade_area(true)
	player.action_component.set_current_order(customer_entity.get_order() if customer_entity else {})

func _on_trade_area_exited(body: Node) -> void:
	var player: Player = _entity_spawn_controller.get_player()
	if body.is_in_group("player"):
		player.action_component.set_trading_enabled(false)
	elif body.is_in_group("customer"):
		player.action_component.set_customer_in_trade_area(false)
		if body == _current_trade_customer:
			_current_trade_customer = null

## Clears the fulfilled customer's order bubble once TradingComponent confirms
## the inventory mutation succeeded.
func _on_trade_completed() -> void:
	if _current_trade_customer == null:
		return
	var order_component: CustomerOrderComponent = _current_trade_customer.get_node_or_null("CustomerOrderComponent")
	if order_component:
		order_component.clear_order()
