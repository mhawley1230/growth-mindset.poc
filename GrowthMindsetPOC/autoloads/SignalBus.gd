extends Node

signal on_level_ready(level: Level)
signal on_player_ready(player: Player)
signal on_cursor_ready(cursor: Cursor)

signal on_plant_inventory_updated(product: String, number: int)
signal on_seed_inventory_updated(seed: String, number: int)
signal on_stage_track_ready(stage_track: Path2D)
#signal on_customer_ready(customer: CustomerEntity)
#signal on_customer_despawn(customer: CustomerEntity)
signal on_customer_trade_area_entered(area: Area2D, body: CharacterBody2D)
signal on_trade_complete()
signal on_trade_area_entered(area: Area2D)
signal on_trade_area_exited()


## Node ready signals
func emit_on_level_ready(level: Level) -> void:
	on_level_ready.emit(level)


func emit_on_player_ready(player: Player) -> void:
	on_player_ready.emit(player)


func emit_on_cursor_ready(cursor: Cursor) -> void:
	on_cursor_ready.emit(cursor)


#func emit_on_customer_ready(customer: Customer) -> void:
	#on_customer_ready.emit(customer)


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


#
#func emit_on_customer_despawn(customer: Customer) -> void:
	#on_customer_despawn.emit(customer)


func emit_on_customer_trade_area_entered(area: Area2D, body: CharacterBody2D) -> void:
	on_customer_trade_area_entered.emit(area, body)



