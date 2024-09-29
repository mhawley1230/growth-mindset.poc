extends Node

signal on_product_collected(product: String)
signal on_game_state_manager_ready(game_state_manager: GameStateManager)
signal on_player_ready(player: PlayerEntity)
signal on_cursor_ready(cursor: CursorEntity)
signal on_stage_track_ready(stage_track: Path2D)
signal on_customer_ready(customer: CustomerEntity)
signal on_customer_despawn(customer: CustomerEntity)
signal on_customer_wait_area_entered()
signal on_trade_complete()

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
func emit_on_product_collected(product: String) -> void:
	on_product_collected.emit(product)


func emit_on_trade_complete() -> void:
	on_trade_complete.emit()


## Customer action signals
func emit_on_customer_despawn(customer: CustomerEntity) -> void:
	on_customer_despawn.emit(customer)


func emit_on_customer_wait_area_entered() -> void:
	on_customer_wait_area_entered.emit()



