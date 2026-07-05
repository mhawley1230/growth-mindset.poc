class_name PlantsBox
extends PanelContainer

## Two-column grid: each plant product occupies an [icon, count] pair of cells.
@export var grid_display: GridContainer

var _inventory_controller: InventoryController
var _count_labels: Dictionary = {}  # product (String) -> Label

func initialize(inventory_controller: InventoryController) -> void:
	bind_services(inventory_controller)
	bind_events()
	update_inventory()

func bind_services(inventory_controller: InventoryController) -> void:
	_inventory_controller = inventory_controller

func bind_events() -> void:
	_inventory_controller.on_inventory_updated.connect(update_inventory)

func update_inventory() -> void:
	if _inventory_controller == null or grid_display == null:
		return
	var plants: Dictionary[String, int] = _inventory_controller.get_category("plants")
	for product: String in plants:
		if not _count_labels.has(product):
			_add_entry(product)
		var count_label: Label = _count_labels[product]
		count_label.text = str(int(plants[product]))

## Builds the icon + count cells for a product, once, on first sight.
func _add_entry(product: String) -> void:
	var icon: TextureRect = TextureRect.new()
	icon.texture = InventoryIcons.get_icon("plants", product)
	icon.custom_minimum_size = Vector2(48, 48)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.tooltip_text = product
	grid_display.add_child(icon)

	var count: Label = Label.new()
	count.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	count.size_flags_vertical = Control.SIZE_EXPAND_FILL
	count.add_theme_font_size_override("font_size", 28)
	grid_display.add_child(count)

	_count_labels[product] = count
