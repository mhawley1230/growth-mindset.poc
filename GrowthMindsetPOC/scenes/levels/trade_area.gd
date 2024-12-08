class_name TradeArea
extends Area2D


func _on_trade_area_entered(body):
	if body.is_in_group("player"):
		SignalBus.on_trade_area_entered.emit(self)


func _on_trade_area_exited(_body):
	SignalBus.on_trade_area_exited.emit()
