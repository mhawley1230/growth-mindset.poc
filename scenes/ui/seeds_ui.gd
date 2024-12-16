class_name SeedsUI
extends Control

#region inventory
@onready var manager_container = NodeExtensions.get_manager_container()
@onready var inventory_manager: InventoryManager = null
#endregion

#region labels
@onready var tomato_seed_label: Label = %TomatoSeedLabel
@onready var potato_seed_label: Label = %PotatoSeedLabel
#endregion


func _ready() -> void:
	SignalBus.on_seed_inventory_updated.connect(on_seed_inventory_updated)
	
	if manager_container == null: 
		return 
	
	inventory_manager = manager_container.get_node("InventoryManager")


func on_seed_inventory_updated(plant: Plant):
	match plant.name.to_lower():
		"tomato":
			tomato_seed_label.text = str(inventory_manager.get_inventory("seed", "tomato"))
		"potato":
			potato_seed_label.text = str(inventory_manager.get_inventory("seed", "potato"))
