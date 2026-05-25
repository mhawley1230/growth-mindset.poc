class_name TradeArea
extends Area2D


#func _on_trade_area_entered(body):
	#if body.is_in_group("player"):
		#SignalBus.on_trade_area_entered.emit(self)
	#
	#if body.is_in_group("customer"):
		#SignalBus.on_customer_trade_area_entered.emit(self, body)
#
#
#func _on_trade_area_exited(_body):
	#SignalBus.on_trade_area_exited.emit()
