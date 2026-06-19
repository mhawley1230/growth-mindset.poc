class_name CustomerOrderComponent
extends Node

@export var products: Array[PlantData]
@export var max_order_size: int

var order: Dictionary = {}

func _ready() -> void:
	add_order(create_order())

## Builds a random order keyed by product name, e.g. { "tomato": 2 }, whose
## quantities sum to at most max_order_size. Some products may get zero.
func create_order() -> Dictionary:
	var result: Dictionary = {}
	if products.is_empty() or max_order_size <= 0:
		order = result
		return order

	var remaining: int = max_order_size
	for product: PlantData in products:
		if product == null or remaining <= 0:
			continue
		var qty: int = randi_range(0, remaining)
		if qty > 0:
			result[product.plant_name] = qty
			remaining -= qty

	order = result
	return order


func add_order(dict: Dictionary) -> void:
	var panel_container = PanelContainer.new()
	add_child(panel_container)

	var margin_container = MarginContainer.new()
	panel_container.add_child(margin_container)
	
	var grid_container = GridContainer.new()
	margin_container.add_child(grid_container)
	
	# configure container nodes
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
