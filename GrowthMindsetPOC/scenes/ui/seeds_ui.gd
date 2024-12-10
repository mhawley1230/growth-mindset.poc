class_name SeedsUI
extends Control

#region inventory
@onready var manager_container = NodeExtensions.get_manager_container()
@onready var inventory_manager: InventoryManagerComponent = null
#endregion

#region labels
@onready var tomato_seed_label: Label = %TomatoSeedLabel
@onready var potato_seed_label: Label = %PotatoSeedLabel
#endregion


func _ready() -> void:
	if manager_container == null: 
		return 
	
	inventory_manager = manager_container.get_node("InventoryManager")


func _physics_process(_delta) -> void:
	tomato_seed_label.text = str(inventory_manager.get_inventory("seeds", "tomato"))
	potato_seed_label.text = str(inventory_manager.get_inventory("seeds", "potato"))
