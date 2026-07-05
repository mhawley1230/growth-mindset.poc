class_name SeedEntry
extends Control

## Single icon+count widget for one seed product. Instanced once per product
## by SeedsBox and reused (overwritten) whenever that product's count changes.


@onready var _icon: TextureRect = %Icon
@onready var _count_label: Label = %CountLabel

## Sets the icon/tooltip for the product this entry represents. Called once,
## right after instancing.
func setup(texture: Texture2D, tooltip: String) -> void:
	_icon.texture = texture
	_icon.tooltip_text = tooltip

## Overwrites the displayed count. Called every time the inventory changes.
func set_count(count: int) -> void:
	_count_label.text = str(count)
