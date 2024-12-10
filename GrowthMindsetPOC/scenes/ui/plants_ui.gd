class_name PlantsUI
extends Control

#region inventory
@onready var manager_container = NodeExtensions.get_manager_container()
@onready var inventory_manager: InventoryManagerComponent = null
#endregion

#region labels
@onready var tomato_label: Label = %TomatoLabel
@onready var potato_label: Label = %PotatoLabel
#endregion


func _ready() -> void:
	if manager_container == null: 
		return 
	
	inventory_manager = manager_container.get_node("InventoryManager")


func _physics_process(_delta) -> void:
	tomato_label.text = str(inventory_manager.get_inventory("plants", "tomato"))
	potato_label.text = str(inventory_manager.get_inventory("plants", "potato"))
