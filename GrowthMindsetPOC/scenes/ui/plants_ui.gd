class_name PlantsUI
extends Control

#region labels
@onready var tomato_label: Label = %TomatoLabel
@onready var potato_label: Label = %PotatoLabel
#endregion


func _ready() -> void:
	SignalBus.on_plant_inventory_updated.connect(on_plant_inventory_updated)
 

func on_plant_inventory_updated(plant: Plant):
	match plant.name.to_lower():
		"tomato":
			tomato_label.text = str(
					Global.inventory_manager.get_inventory("plant", "tomato"))
		"potato":
			potato_label.text = str(
					Global.inventory_manager.get_inventory("plant", "potato"))
