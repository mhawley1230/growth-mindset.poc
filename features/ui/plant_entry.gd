class_name PlantEntry
extends Control

## Single icon+count widget for one plant product. Instanced once per product
## by PlantsBox and reused (overwritten) whenever that product's count changes.
## Mirrors SeedEntry.

## Count font height as a fraction of the icon's rendered height. The font
## tracks the icon so the number stays legible at any box size or resolution.
@export_range(0.05, 1.0, 0.01) var count_to_icon_ratio: float = 0.4
## Legibility floor so the number never collapses to an unreadable size.
@export var min_font_size: int = 6

@onready var _icon: TextureRect = %Icon
@onready var _count_label: Label = %CountLabel

func _ready() -> void:
	# The icon is sized by its AspectRatioContainer (box fit) and then displayed
	# through HUDLayer's transform (resolution). Reading the icon's rect keeps the
	# font on that same single scale, so it never double-scales with resolution.
	_icon.resized.connect(_rescale_font)
	_rescale_font()

## Sets the icon/tooltip for the product this entry represents. Called once,
## right after instancing.
func setup(texture: Texture2D, tooltip: String) -> void:
	_icon.texture = texture
	_icon.tooltip_text = tooltip

## Overwrites the displayed count. Called every time the inventory changes.
func set_count(count: int) -> void:
	_count_label.text = str(count)

## Matches the count font size to the icon's current rendered height.
func _rescale_font() -> void:
	var font_size: int = maxi(min_font_size, roundi(_icon.size.y * count_to_icon_ratio))
	_count_label.add_theme_font_size_override("font_size", font_size)
