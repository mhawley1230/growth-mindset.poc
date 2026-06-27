class_name PlantsUI
extends Control
#
#
#@onready var grid_container: GridContainer = %GridContainer
#
#
#func _init() -> void:
	#Global.plants_ui = self
	#SignalBus.on_plant_inventory_updated.connect(on_plant_inventory_updated)
#
#
#func _ready() -> void:
	#_create_textures_and_labels()
 ##
##
#func _create_textures_and_labels() -> void:
	#for i: int in icons.size():
		## Create plant icon
		#var texture_rect: TextureRect = TextureRect.new()
		#grid_container.add_child(texture_rect)
		#texture_rect.texture = icons[i]
		#
		## Center icon in container
		#texture_rect.set_expand_mode(TextureRect.EXPAND_FIT_WIDTH)
		#texture_rect.set_h_size_flags(SIZE_EXPAND_FILL)
		#
		## Create label
		#var label: Label = Label.new()
		#grid_container.add_child(label)
		#label.text = "000"
		#
		## Center label in container
		#label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
		#label.set_h_size_flags(SIZE_EXPAND_FILL)
		#label.add_theme_font_size_override("font_size", 60)
		#label.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
#
#
#func on_plant_inventory_updated(plant_name: String) -> void:
	#var children: Array[Node] = grid_container.get_children()
	#
	#for i: int in children.size():
		#if children[i] is TextureRect:
			#var icon: TextureRect = children[i]
			#var icon_path: String = icon.texture.resource_path
			#
			#if plant_name == Utils.get_name_from_load_path(icon_path):
				#children[i + 1].text = str(Global.inventory_manager.get_inventory(
					#"plants", plant_name)[plant_name])
