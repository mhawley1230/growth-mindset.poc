class_name CustomerOrderHandler
extends Node

@onready var level: Node = get_tree().get_first_node_in_group("level")
@onready var products: Array[Plant] = level.available_products
@onready var max_order_size: int = level.cust_max_order_size
@onready var order_container: Node2D = %OrderContainer
@onready var order: Dictionary = {}

## 1. assign random number between 0 and 
## order size to each available product in level
## 	 - some can have less then total order size
## 2. validate that sum of ordered products 
## is less than order size
## create UI element and add product icons and nums
## to customer entity
func create_order() -> Dictionary:
	var random_numbers: Array = Globals.generate_numbers(products.size(), max_order_size)
	
	for i in random_numbers.size():
		var product = products.pick_random().name
		
		if order.has(product):
			order[product] += random_numbers[i]
		else:
			order[product] = random_numbers[i]
	return order


func add_order(dict: Dictionary) -> void:
	if order_container == null:
		return

	# Create the ui containers
	var control = Control.new()
	order_container.add_child(control)
	
	var panel_container = PanelContainer.new()
	control.add_child(panel_container)
	
	var margin_container = MarginContainer.	new()
	panel_container.add_child(margin_container)
	
	var grid_container = GridContainer.new()
	margin_container.add_child(grid_container)
	
	# configure container nodes
	control.scale =  Vector2(0.5, 0.5)
	grid_container.columns = 2
	
	# Set margins
	var margin_value: int = 4
	margin_container.add_theme_constant_override("margin_left", margin_value)
	margin_container.add_theme_constant_override("margin_top", margin_value)
	margin_container.add_theme_constant_override("margin_right", margin_value)
	margin_container.add_theme_constant_override("margin_bottom", margin_value)
	
	# Create icons and labels
	for item in dict:
		var icon_path: String = str("res://assets/" + item + "_icon.png")
		
		var texture_rect = TextureRect.new()
		grid_container.add_child(texture_rect)
		texture_rect.texture = load(icon_path)
		
		var label = Label.new()
		label.text = str(dict[item])
		grid_container.add_child(label)
	
	# Position panel above customer sprite
	var height: float = panel_container.get_minimum_size().y
	panel_container.set_position(Vector2(0,-height))
