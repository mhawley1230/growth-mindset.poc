class_name TradeArea
extends Area2D

# Local signals replace the old global SignalBus. The level (or the customer
# spawn authority) connects these to the player's ActionComponent setters.
signal player_entered
signal customer_entered(customer: Node)
signal trade_area_exited(body: Node)

func _ready() -> void:
	# Self-wire to the built-in Area2D body signals so no manual scene
	# connection is required.
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print("body entered " + str(body.name))
		player_entered.emit()
	elif body.is_in_group("customer"):
		customer_entered.emit(body)
		print("body entered " + str(body.name))

func _on_body_exited(body: Node) -> void:
	trade_area_exited.emit(body)
