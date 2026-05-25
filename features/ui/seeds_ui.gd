class_name SeedsUI
extends Control
#
#@onready var hbox_container: HBoxContainer = %HBoxContainer
#
#
#
#func _on_tree() -> void:
	#Global.seeds_ui = self
#
#
#func _ready() -> void:
	#_create_textures_and_labels()
	#
	#SignalBus.on_seed_inventory_updated.connect(on_seed_inventory_updated)
#
#
#func _create_textures_and_labels() -> void:
	##pass
	#if Global.level == null:
		#return
	#
	#var icons: Array[Texture2D] = Global.level.available_product_icons
	#for i: int in icons.size():
		## Reverse lookup to grab type from level icons, feels hacky
		#var key: int = Refs.plant_icons.find_key(icons[i])
		#var icon: Texture2D = Refs.get_plant_seed_icon_by_type(key)
		#
		#var margins: MarginContainer = MarginContainer.new()
		#hbox_container.add_child(margins)
		#
		## Create seed icons
		#var texture_rect: TextureRect = TextureRect.new()
		#margins.add_child(texture_rect)
		#texture_rect.texture = icon
		#
		## Center icon in container
		#texture_rect.custom_minimum_size = Vector2(75,75)
		#texture_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#texture_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
		#
		## Create label
		#var label: Label = Label.new()
		#texture_rect.add_child(label)
		#label.set_anchors_preset(Control.PRESET_TOP_RIGHT)
		#label.add_theme_font_size_override("font_size", 16)
		#
#
#
#func on_seed_inventory_updated(seed_name: String) -> void:
	#var children: Array[Node] = hbox_container.get_children()
	#
	#for i: int in children.size():
		#var icon: TextureRect = children[i].get_child(0)
		##print(seed_name, num)
		#var label: Label = icon.get_child(0)
		#
		#if seed_name == Utils.get_name_from_load_path(
				#icon.texture.resource_path):
			#label.text = str(Global.inventory_manager.get_inventory(
					#"seeds", seed_name)[seed_name])
