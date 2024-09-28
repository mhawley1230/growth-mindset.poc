extends Node


signal on_plant_collected(product: String)
signal on_game_state_manager_ready(game_state_manager: GameStateManager)
signal on_player_ready(player: PlayerEntity)
signal on_cursor_ready(cursor: CursorEntity)
signal on_stage_track_ready(stage_track: Path2D)
signal on_customer_ready(customer: CustomerEntity)
signal on_customer_despawn(customer: CustomerEntity)
signal on_wait_area_entered(wait_area: WaitArea)
#signal on_trade_complete()

func emit_on_plant_collected(plant: String) -> void:
	on_plant_collected.emit(plant)


func emit_on_game_state_manager_ready(game_state_manager: GameStateManager) -> void:
	on_game_state_manager_ready.emit(game_state_manager)


func emit_on_player_ready(player: PlayerEntity) -> void:
	on_player_ready.emit(player)


func emit_on_cursor_ready(cursor: CursorEntity) -> void:
	on_cursor_ready.emit(cursor)


func emit_on_stage_track_ready(stage_track: Path2D) -> void:
	on_stage_track_ready.emit(stage_track)


func emit_on_customer_ready(customer: CustomerEntity) -> void:
	on_customer_ready.emit(customer)


func emit_on_customer_despawn(customer: CustomerEntity) -> void:
	on_customer_despawn.emit(customer)


func emit_on_wait_area(wait_area: WaitArea) -> void:
	on_wait_area_entered.emit(wait_area)
