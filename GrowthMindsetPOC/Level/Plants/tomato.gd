extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var progress_bar = get_node("TextureProgressBar")
	
	if progress_bar.value == progress_bar.max_value:
		#progress_bar.queue_free()
		progress_bar.set_visible(false)
	#pass
