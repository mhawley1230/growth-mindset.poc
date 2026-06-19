class_name HarvestingComponent
extends Node

## Harvests any ready plant overlapped by the cursor, crediting one to inventory.
func harvest_plant(areas: Array[Area2D], inventory: InventoryController) -> void:
	if inventory == null:
		return

	for area: Area2D in areas:
		if not area.is_in_group("plant"):
			continue
		if area is PlantEntity and not (area as PlantEntity).isHarvestable:
			continue
		var plant_type: String = _strip_id(area.name)
		inventory.add("plants", plant_type, 1)
		area.queue_free()

## Plants are named "<Type><instance_id>" when planted; strip the trailing digits
## to recover the product key.
func _strip_id(node_name: String) -> String:
	return node_name.to_lower().rstrip("0123456789")
