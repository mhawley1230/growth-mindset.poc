class_name PlantsBox
extends PanelContainer

@export var grid_display: GridContainer

var _inventory_controller: InventoryController

func initialize(inventory_controller: InventoryController) -> void:
	bind_services(inventory_controller)
	bind_events()

func bind_services(inventory_controller: InventoryController) -> void:
	_inventory_controller = inventory_controller

func bind_events() -> void:
	_inventory_controller.on_inventory_updated.connect(update_inventory)

func update_inventory() -> void:
	# Reads are safe before any display exists. Visual layout of plant counts is
	# wired once the overlay scene is attached to GameContext (see ARCHITECTURE_REVIEW).
	if _inventory_controller == null:
		return
	var _plants: Dictionary = _inventory_controller.get_category("plants")
