class_name SeedsBox
extends PanelContainer

@export var label: HBoxContainer

var _inventory_controller: InventoryController

func initialize(inventory_controller: InventoryController) -> void:
	bind_services(inventory_controller)
	# bind_events()

func bind_services(inventory_controller: InventoryController) -> void:
	_inventory_controller = inventory_controller

func bind_events() -> void:
	_inventory_controller.on_inventory_updated.connect(update_inventory)

func update_inventory() -> void:
	pass
