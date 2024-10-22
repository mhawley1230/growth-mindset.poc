class_name SeedsUI
extends Control

@onready var tomato_seed_label: Label = %TomatoSeedLabel
@onready var potato_seed_label: Label = %PotatoSeedLabel

#
#func _physics_process(_delta) -> void:
	#tomato_seed_label.text = str(Inventory.get_product("tomato", true)["tomato"])
	#potato_seed_label.text = str(Inventory.get_product("potato", true)["potato"])
