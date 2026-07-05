class_name SeedsBox
extends PanelContainer

## Horizontal container that holds one icon+count entry per seed product.
@export var label: HBoxContainer

## Reusable per-product widget (icon + count), instanced once per product and
## overwritten in place afterwards. See features/inventory/seed_entry.tscn.
@export var seed_entry_scene: PackedScene

var _inventory_controller: InventoryController
var _entries: Dictionary = {}  # product (String) -> SeedEntry

func initialize(inventory_controller: InventoryController) -> void:
	bind_services(inventory_controller)
	bind_events()
	update_inventory()

func bind_services(inventory_controller: InventoryController) -> void:
	_inventory_controller = inventory_controller

func bind_events() -> void:
	_inventory_controller.on_inventory_updated.connect(update_inventory)

func update_inventory() -> void:
	if _inventory_controller == null or label == null or seed_entry_scene == null:
		return
	var seeds: Dictionary[String, int] = _inventory_controller.get_category("seeds")
	for product: String in seeds:
		if not _entries.has(product):
			_add_entry(product)
		var entry: SeedEntry = _entries[product]
		entry.set_count(seeds[product])

## Instances the reusable seed entry scene for a product, once, on first
## sight. Its icon/tooltip are set here; its count is overwritten afterwards
## by update_inventory() every time the inventory changes.
func _add_entry(product: String) -> void:
	var entry: SeedEntry = seed_entry_scene.instantiate()
	label.add_child(entry)
	entry.setup(InventoryIcons.get_icon("seeds", product), product)
	_entries[product] = entry
