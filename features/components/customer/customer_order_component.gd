class_name CustomerOrderComponent
extends Control

@export var products: Array[PlantData]
@export var max_order_size: int

var order: Dictionary = {}

func _ready() -> void:
	add_order(create_order())

## Builds a random order keyed by product name, e.g. { "tomato": 2 }, whose
## quantities sum to at most max_order_size. Some products may get zero, but
## the roll is never allowed to leave every product at zero (see below) --
## an empty order can never be fulfilled, which would strand the customer.
func create_order() -> Dictionary:
	var result: Dictionary[String, int] = {}
	if products.is_empty() or max_order_size <= 0:
		order = result
		return order

	var remaining: int = max_order_size
	for product: PlantData in products:
		if product == null or remaining <= 0:
			continue
		var qty: int = randi_range(1, remaining)
		if qty > 0:
			result[product.plant_name] = qty
			remaining -= qty

	# Every product rolled zero -- force one non-null product to a non-zero
	# quantity so the order is guaranteed fulfillable.
	if result.is_empty():
		var valid_products: Array[PlantData] = products.filter(
			func(p: PlantData) -> bool: return p != null)
		if not valid_products.is_empty():
			var chosen: PlantData = valid_products[randi() % valid_products.size()]
			result[chosen.plant_name] = randi_range(1, max_order_size)

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

func get_order() -> Dictionary:
	return order
