class_name PlantsBox
extends PanelContainer

## Vertical list of plant products; each product is one reusable PlantEntry
## (icon + count) row. The box sizes to its content, so it grows in height as
## more products appear. Mirrors SeedsBox, but stacked vertically.
@export var entry_list: VBoxContainer

## Reusable per-product widget (icon + count), instanced once per product and
## overwritten in place afterwards. See features/ui/plant_entry.tscn.
@export var plant_entry_scene: PackedScene

var _inventory_controller: InventoryController
var _entries: Dictionary = {}  # product (String) -> PlantEntry

func initialize(inventory_controller: InventoryController) -> void:
	bind_services(inventory_controller)
	bind_events()
	update_inventory()

func bind_services(inventory_controller: InventoryController) -> void:
	_inventory_controller = inventory_controller

func bind_events() -> void:
	_inventory_controller.on_inventory_updated.connect(update_inventory)

func update_inventory() -> void:
	if _inventory_controller == null or entry_list == null or plant_entry_scene == null:
		return
	var plants: Dictionary[String, int] = _inventory_controller.get_category("plants")
	for product: String in plants:
		if not _entries.has(product):
			_add_entry(product)
		var entry: PlantEntry = _entries[product]
		entry.set_count(plants[product])

## Instances the reusable plant entry scene for a product, once, on first
## sight. Its icon/tooltip are set here; its count is overwritten afterwards
## by update_inventory() every time the inventory changes.
func _add_entry(product: String) -> void:
	var entry: PlantEntry = plant_entry_scene.instantiate()
	entry_list.add_child(entry)
	entry.setup(InventoryIcons.get_icon("plants", product), product)
	_entries[product] = entry
