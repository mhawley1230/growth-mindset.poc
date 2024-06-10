extends Node

signal on_product_collected(product: String)
signal on_player_ready(player: PlayerEntity)
signal on_game_state_manager_ready(game_state_manager: GameStateManager)
signal on_enemy_despawn
signal on_is_within_farm_plot
signal on_is_outside_farm_plot


func emit_is_within_farm_plot(is_within: bool) -> void:
	on_is_within_farm_plot.emit(is_within)

func emit_on_enemy_despawn() -> void:
	on_enemy_despawn.emit()


func emit_on_game_state_manager_ready(game_state_manager: GameStateManager) -> void:
	on_game_state_manager_ready.emit(game_state_manager)


func emit_on_product_collected(product: String) -> void:
	on_product_collected.emit(product)


func emit_on_player_ready(player: PlayerEntity) -> void:
	on_player_ready.emit(player)
