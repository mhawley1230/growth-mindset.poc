class_name PlantsUI
extends Control

@onready var tomato_label: Label = %TomatoLabel
@onready var potato_label: Label = %PotatoLabel


#func _physics_process(_delta) -> void:
	#tomato_label.text = str(Inventory.get_product("tomato", false)["tomato"])
	#potato_label.text = str(Inventory.get_product("potato", false)["potato"])
