extends Node

signal on_plant_inventory_updated(product: String, number: int)
signal on_seed_inventory_updated(seed: String, number: int)
signal on_game_state_manager_ready(game_state_manager: GameStateManager)
signal on_player_ready(player: PlayerEntity)
signal on_cursor_ready(cursor: CursorEntity)
signal on_stage_track_ready(stage_track: Path2D)
signal on_customer_ready(customer: CustomerEntity)
signal on_customer_despawn(customer: CustomerEntity)
signal on_customer_wait_area_entered(body: CharacterBody2D)
signal on_trade_complete()
signal on_trade_area_entered(area: Area2D)
signal on_trade_area_exited()


## Game state signals
func emit_on_game_state_manager_ready(game_state_manager: GameStateManager) -> void:
	on_game_state_manager_ready.emit(game_state_manager)


## Entity signals
func emit_on_player_ready(player: PlayerEntity) -> void:
	on_player_ready.emit(player)


func emit_on_cursor_ready(cursor: CursorEntity) -> void:
	on_cursor_ready.emit(cursor)


func emit_on_customer_ready(customer: CustomerEntity) -> void:
	on_customer_ready.emit(customer)


## Player action signals
func emit_on_plant_inventory_updated(product_name: String, number: int) -> void:
	on_plant_inventory_updated.emit(product_name, number)


func emit_on_seed_inventory_updated(seed_name: String, number: int) -> void:
	on_seed_inventory_updated.emit(seed_name, number)


func emit_on_trade_complete() -> void:
	on_trade_complete.emit()


func emit_on_trade_area_entered(area: Area2D) -> void:
	on_trade_area_entered.emit(area)


func emit_on_trade_area_exited() -> void:
	on_trade_area_exited.emit()

## Customer action signals
func emit_on_customer_despawn(customer: CustomerEntity) -> void:
	on_customer_despawn.emit(customer)


func emit_on_customer_wait_area_entered(body: CharacterBody2D) -> void:
	on_customer_wait_area_entered.emit(body)



