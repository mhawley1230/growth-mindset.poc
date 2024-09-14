extends Node


signal on_plant_collected(product: String)
signal on_game_state_manager_ready(game_state_manager: GameStateManager)
signal on_player_ready(player: PlayerEntity)
signal on_cursor_ready(cursor: CursorEntity)
#signal on_enemy_despawn


func emit_on_plant_collected(plant: String) -> void:
	on_plant_collected.emit(plant)


func emit_on_game_state_manager_ready(game_state_manager: GameStateManager) -> void:
	on_game_state_manager_ready.emit(game_state_manager)


func emit_on_player_ready(player: PlayerEntity) -> void:
	on_player_ready.emit(player)


func emit_on_cursor_ready(cursor: CursorEntity) -> void:
	on_cursor_ready.emit(cursor)


#func emit_on_enemy_despawn() -> void:
	#on_enemy_despawn.emit()
