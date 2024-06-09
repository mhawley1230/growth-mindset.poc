class_name Cursor
extends Node2D

#@onready var input_handler = $InputHandler as InputHandler
#@onready var player = get_tree().root.get_node("Main/EntityContainer/PlayerEntity")
#@onready var tile_map = get_tree().root.get_node("Main/LevelContainer/GameLevel/TileMap")
#@onready var tile_size: Vector2 = Vector2(tile_map.tile_set.tile_size)
#@onready var farm_plots = get_tree().root.get_node("SceneTree/GameLevel/Farm/FarmPlotHolder")

#func _process(_delta):
	#var grid_pos = tile_map.local_to_map(player.get_position())
	#var local_grid_pos = tile_map.map_to_local(grid_pos)
	#
	##print(str(grid_pos) + ", " + str(local_grid_pos))
	 #
	#if input_dir != Vector2.ZERO:
		#position = snapped(local_grid_pos, Vector2(tile_size))
		#print(tile_map.local_to_map(position))
		

#func is_cursor_within_farm_plot():
	#var result = false
	#var position_x = int(position.x)
	#var position_y = int(position.y)
	#
	#for plot in farm_plots.get_children():
		#var min_x = plot.position.x
		#var min_y = plot.position.y
		#var plot_size = plot.get_dimensions()
		#var max_x = min_x + plot_size.x
		#var max_y = min_y + plot_size.y
		#
		#if min_x <= position_x and position_x <= max_x and min_y <= position_y and position_y <= max_y:
			#result = true
#
	#return result
