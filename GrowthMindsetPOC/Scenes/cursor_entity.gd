class_name CursorEntity
extends Area2D

func ready():
	SignalBus.emit_on_cursor_ready(self)
