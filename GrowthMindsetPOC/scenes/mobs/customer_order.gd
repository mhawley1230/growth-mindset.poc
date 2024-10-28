class_name CustomerOrderHandler
extends Node

@onready var level_container: Node = NodeExtensions.get_level_container()
@onready var level: Node = level_container.get_child(0)
@onready var products: Array[Plant] = level.available_products
@onready var max_order_size: int = level.cust_max_order_size

## 1. assign random number between 0 and 
## order size to each available product in level
## 	 - some can have less then total order size
## 2. validate that sum of ordered products 
## is less than order size
## create UI element and add product icons and nums
## to customer entity
func create_order() -> Dictionary:
	if level_container == null:
		return {}
	
	var order: Dictionary = {}
	var random_numbers: Array = Globals.generate_numbers(products.size(), max_order_size)
	
	for i in random_numbers.size():
		var product = products[randi_range(0, products.size() - 1)].name
		
		if order.has(product):
			order[product] += random_numbers[i]
		else:
			order[product] = random_numbers[i]
	
	print(order)
	return order


func add_order(dict: Dictionary):
	for e in dict:
		print(e, dict[e])
