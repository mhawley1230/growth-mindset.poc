class_name CustomerOrderComponent
extends Control

@export var products: Array[PlantData]
@export var max_order_size: int

var order: Dictionary = {}

func _ready() -> void:
	add_order(create_order())

## Builds a random order keyed by product name, e.g. { "tomato": 2 }, whose
## quantities sum to at most max_order_size. Some products may get zero.
func create_order() -> Dictionary:
	var result: Dictionary[String, int] = {}
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


func add_order(dict: Dictionary[String, int]) -> void:
	var panel_container: PanelContainer = PanelContainer.new()
	add_child(panel_container)

	var margin_container: MarginContainer = MarginContainer.new()
	panel_container.add_child(margin_container)
	
	var grid_container: GridContainer = GridContainer.new()
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
	for item: String in dict:
		var icon_path: String = str("res://assets/" + item + "_icon.png")
		
		var texture_rect: TextureRect = TextureRect.new()
		grid_container.add_child(texture_rect)
		texture_rect.texture = load(icon_path)
		
		var label: Label = Label.new()
		label.text = str(dict[item])
		grid_container.add_child(label)
	
	# Position panel above customer sprite
	panel_container.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)

## Called once a trade fulfills this customer's order: drops the order data and
## frees the bubble UI so it no longer shows an outstanding order.
func clear_order() -> void:
	order = {}
	for child: Node in get_children():
		child.queue_free()

func get_order() -> Dictionary[String, int]:
	return order
