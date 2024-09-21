class_name CursorManager
extends Node


func _ready():
	SignalBus.on_cursor_ready.connect(on_cursor_ready)


func on_cursor_ready(_cursor: CursorEntity) -> void:
	## After cursor loads, do something
	pass
