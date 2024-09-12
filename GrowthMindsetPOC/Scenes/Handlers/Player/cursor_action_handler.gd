class_name CursorActionHandler
extends Node

#func planting_enabled(areas: Array[Area2D]) -> bool:
	#var enabled: bool = false
	#
	#
	### check if cursor is over farm_plot
	###	if cursor is over farm_plot, check if a plant is present
	### 	then enable planting, else false
	#
	#if $CursorEntity.has_over
	#
	##for area in areas:
		##if area is FarmPlot and areas.size() == 1:
			##enabled = true
		##if area is PlantEntity and areas.size() == 2:
			##enabled = false
	#return enabled
