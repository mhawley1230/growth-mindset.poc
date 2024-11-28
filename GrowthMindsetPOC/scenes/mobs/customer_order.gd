class_name CustomerOrderHandler
extends Node

@onready var level_container: Node = NodeExtensions.get_level_container()
@onready var level: Level = level_container.get_child(0)
@onready var products: Array[Plant] = level.available_products
@onready var max_order_size: int = level.cust_max_order_size
@onready var customer_order: Node2D = %CustomerOrder

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
		var product = products.pick_random().name
		
		if order.has(product):
			order[product] += random_numbers[i]
		else:
			order[product] = random_numbers[i]
	return order


func add_order(dict: Dictionary):
	if customer_order == null:
		return

	# Create the Control node
	var control = Control.new()
	customer_order.add_child(control)
	
#
	# Create HBoxContainer
	var box = BoxContainer.new()
	control.add_child(box)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
#
	# Create TextureRect
	var texture_rect = TextureRect.new()
	box.add_child(texture_rect)
	
	print(dict)
	for e in dict:
		var icon_path = str("res://assets/" + e + "_icon.png")
		texture_rect.texture = load(icon_path)  # Replace with your texture path
		##  # Minimum size for TextureRect
##
		### Create Label
		var label = Label.new()
		label.text = str(dict[e])
		#label.text = "2"
		label.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
		texture_rect.add_child(label)
	

