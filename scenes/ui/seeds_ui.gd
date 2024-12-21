class_name SeedsUI
extends Control

@onready var hbox_container := %HBoxContainer

#region labels
#@onready var tomato_seed_label: Label = %TomatoSeedLabel
#@onready var potato_seed_label: Label = %PotatoSeedLabel
#endregion


func _ready() -> void:
	SignalBus.on_seed_inventory_updated.connect(on_seed_inventory_updated)
	_create_textures_and_labels()


func _create_textures_and_labels():
	#pass
	if Global.level.available_product_icons == null:
		return
	
	for i in Global.level.available_product_icons:
		var index: int = 0
		# Reverse lookup to grab type from level icons, feels hacky
		var key: int = Refs.plant_icons.find_key(i)
		var icon: Texture2D = Refs.get_plant_seed_icon_by_type(key)
		
		# Create seed icons
		var texture_rect := TextureRect.new()
		hbox_container.add_child(texture_rect)
		texture_rect.texture = icon
		
		# Center icon in container
		#texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		#texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
		texture_rect.custom_minimum_size = Vector2(75,75)
		texture_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#texture_rect.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		texture_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		# Create label
		var label := Label.new()
		texture_rect.add_child(label)
		label.text = str(Global.level.seeds_starting[index])
		
		# Set bottom right anchor
		label.set_anchors_and_offsets_preset(PRESET_BOTTOM_RIGHT)
		index += 1

func on_seed_inventory_updated(seed_name: String, number: int):
	pass
	#match plant.name.to_lower():
		#"tomato":
			#tomato_seed_label.text = str(inventory_manager.get_inventory("seed", "tomato"))
		#"potato":
			#potato_seed_label.text = str(inventory_manager.get_inventory("seed", "potato"))
