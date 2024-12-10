class_name PlantsUI
extends Control

#region inventory
@onready var manager_container = NodeExtensions.get_manager_container()
@onready var inventory_manager: InventoryManager = null
#endregion

#region labels
@onready var tomato_label: Label = %TomatoLabel
@onready var potato_label: Label = %PotatoLabel
#endregion


func _ready() -> void:
	SignalBus.on_plant_inventory_updated.connect(on_plant_inventory_updated)
	
	if manager_container == null: 
		return 
	
	inventory_manager = manager_container.get_node("InventoryManager")

func on_plant_inventory_updated(plant: Plant):
	match plant.name.to_lower():
		"tomato":
			tomato_label.text = str(inventory_manager.get_inventory("plant", "tomato"))
		"potato":
			potato_label.text = str(inventory_manager.get_inventory("plant", "potato"))
