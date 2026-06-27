class_name HUDLayer
extends CanvasLayer

## A camera-scoped HUD that scales its UI to the viewport resolution.
##
## The HUD is authored once against `reference_resolution`. At runtime the layer
## is scaled so that reference canvas maps onto the actual viewport. Because a
## CanvasLayer renders independently of the 2D camera transform, the inventory UI
## stays fixed on screen even while the player's Camera2D pans and zooms.
##
## Parent this under the player's Camera2D so its lifetime is scoped to that
## player. (For true per-camera isolation in split-screen, give each player a
## SubViewport; a shared viewport draws every HUDLayer over the whole screen.)

enum ScaleMode {
	FIT, ## Uniform scale; the whole reference fits on screen (letterboxed).
	COVER, ## Uniform scale; reference covers the screen (edges may crop).
	STRETCH, ## Per-axis scale; fills the screen exactly (may distort).
	WIDTH, ## Uniform scale locked to the width ratio.
	HEIGHT, ## Uniform scale locked to the height ratio.
}

## Resolution the UI is designed against. Defaults to the project window size.
@export var reference_resolution: Vector2 = Vector2(1920, 1080)
@export var scale_mode: ScaleMode = ScaleMode.FIT
## Root Control holding the HUD. Falls back to the first Control child.
@export var ui_root: Control


func _ready() -> void:
	if ui_root == null:
		ui_root = _find_first_control()
	var vp: Viewport = get_viewport()
	if vp:
		vp.size_changed.connect(_apply_scale)
	_apply_scale()


func _apply_scale() -> void:
	if reference_resolution.x <= 0.0 or reference_resolution.y <= 0.0:
		return
	var vp: Viewport = get_viewport()
	if vp == null:
		return

	var screen: Vector2 = Vector2(vp.get_visible_rect().size)
	var sx: float = screen.x / reference_resolution.x
	var sy: float = screen.y / reference_resolution.y

	var factor: Vector2 = Vector2.ONE
	match scale_mode:
		ScaleMode.FIT:
			factor = Vector2.ONE * minf(sx, sy)
		ScaleMode.COVER:
			factor = Vector2.ONE * maxf(sx, sy)
		ScaleMode.STRETCH:
			factor = Vector2(sx, sy)
		ScaleMode.WIDTH:
			factor = Vector2.ONE * sx
		ScaleMode.HEIGHT:
			factor = Vector2.ONE * sy

	scale = factor
	# Center the scaled reference canvas in the viewport (matters for FIT/COVER).
	offset = (screen - reference_resolution * factor) * 0.5

	# Anchored children resolve against the reference rect, then the layer scale
	# maps them onto the real screen, so corner-anchored UI stays in its corner.
	if ui_root:
		ui_root.position = Vector2.ZERO
		ui_root.size = reference_resolution


func _find_first_control() -> Control:
	for child: Node in get_children():
		if child is Control:
			return child as Control
	return null
