class_name TradeArea
extends Node2D

@onready var area: Area2D = $Area2D as Area2D


func _on_trade_area_entered(body):
	if body.name == "PlayerEntity":
		SignalBus.on_trade_area_entered.emit()


func _on_trade_area_exited(_body):
	SignalBus.on_trade_area_exited.emit()
