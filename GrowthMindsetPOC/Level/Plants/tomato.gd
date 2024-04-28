extends Sprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var progress_bar = get_node("TextureProgressBar")
	
	if progress_bar.get_value() >= progress_bar.get_max():
		progress_bar.set_visible(false)
	
