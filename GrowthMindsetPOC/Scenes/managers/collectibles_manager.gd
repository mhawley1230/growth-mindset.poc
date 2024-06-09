class_name CollectiblesManager
extends Node

var tomatoes_collected: int = 0
var potatoes_collected: int = 0
var total_products_collected: int = 0

func _ready():
	SignalBus.on_product_collected.connect(on_product_collected)

func on_product_collected(product_name: String) -> void:
	match product_name:
		"tomato":
			tomatoes_collected += 1
		"potato":
			potatoes_collected += 1
	
	total_products_collected += 1
