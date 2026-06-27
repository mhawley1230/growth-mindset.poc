class_name SeedsBox
extends PanelContainer

## Horizontal container that holds one icon+count entry per seed product.
@export var label: HBoxContainer

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
	if _inventory_controller == null or label == null:
		return
	var seeds: Dictionary = _inventory_controller.get_category("seeds")
	for product: String in seeds:
		if not _count_labels.has(product):
			_add_entry(product)
		var count_label: Label = _count_labels[product]
		count_label.text = str(int(seeds[product]))

## Builds the icon + count widget for a product, once, on first sight.
func _add_entry(product: String) -> void:
	var entry: VBoxContainer = VBoxContainer.new()
	entry.alignment = BoxContainer.ALIGNMENT_CENTER
	label.add_child(entry)

	var icon: TextureRect = TextureRect.new()
	icon.texture = InventoryIcons.get_icon("seeds", product)
	icon.custom_minimum_size = Vector2(64, 64)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.tooltip_text = product
	entry.add_child(icon)

	var count: Label = Label.new()
	count.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	count.add_theme_font_size_override("font_size", 24)
	entry.add_child(count)

	_count_labels[product] = count
