class_name InventoryIcons
extends RefCounted

## Maps an inventory entry (category + product key) to its display icon.
const SEED_ICONS: Dictionary[String, String] = {
	"tomato": "res://assets/tomato_seeds_icon.png",
	"potato": "res://assets/potato_seeds_icon.png",
}

const PLANT_ICONS: Dictionary[String, String] = {
	"tomato": "res://assets/tomato_icon.png",
	"potato": "res://assets/potato_icon.png",
}

## Returns the icon for a product in a category ("seeds" or "plants"),
## or null if the product has no registered icon.
static func get_icon(category: String, product: String) -> Texture2D:
	var table: Dictionary[String, String] = SEED_ICONS if category == "seeds" else PLANT_ICONS
	if not table.has(product):
		push_warning("InventoryIcons: no icon for %s/%s" % [category, product])
		return null
	return load(table[product]) as Texture2D
