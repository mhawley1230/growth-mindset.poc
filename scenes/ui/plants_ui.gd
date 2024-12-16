class_name PlantsUI
extends Control


@onready var grid_container: GridContainer = %GridContainer
##region labels
#@onready var tomato_label: Label = %TomatoLabel
#@onready var potato_label: Label = %PotatoLabel
##endregion


func _ready() -> void:
	SignalBus.on_plant_inventory_updated.connect(on_plant_inventory_updated)
	create_textures_and_labels()
 

func create_textures_and_labels() -> void:
	if Global.level.available_product_icons == null:
		return
	
	#print(Global.level.available_product_icons)
	
	for i in Global.level.available_product_icons:
		var index: int = 0
		# Create plant icon
		var icon := TextureRect.new()
		grid_container.add_child(icon)
		icon.texture = i
		
		# Center icon in container
		icon.set_expand_mode(TextureRect.EXPAND_FIT_WIDTH)
		icon.set_h_size_flags(SIZE_EXPAND_FILL)
		
		# Create label
		var label := Label.new()
		grid_container.add_child(label)
		label.text = str(Global.level.plants_starting[index])
		
		# Center label in container
		label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
		label.set_h_size_flags(SIZE_EXPAND_FILL)
		label.add_theme_font_size_override("font_size", 60)
		
		index += 1
		

func on_plant_inventory_updated(plant: Plant) -> void:
	pass
	#match plant.name.to_lower():
		#"tomato":
			#tomato_label.text = str(
					#Global.inventory_manager.get_inventory("plant", "tomato"))
		#"potato":
			#potato_label.text = str(
					#Global.inventory_manager.get_inventory("plant", "potato"))
