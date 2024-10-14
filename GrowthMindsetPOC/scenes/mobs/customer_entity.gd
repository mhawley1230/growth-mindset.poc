class_name CustomerEntity
extends Node2D


@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D as PathFollow2D
@onready var movement_handler: MovementHandler = $HandlerContainer/MovementHandler as MovementHandler
@onready var customer_sprite: Sprite2D = $Path2D/PathFollow2D/CustomerBody/Sprite2D as Sprite2D
@onready var customer_order: CustomerOrder = $CustomerOrderContainer/CustomerOrder as CustomerOrder

func _ready() -> void:
	SignalBus.on_customer_wait_area_entered.connect(on_customer_wait_area_entered)


func _physics_process(delta: float) -> void:
	path_follow.set_progress(path_follow.get_progress() + movement_handler.movement_speed * delta)
	
	if path_follow.get_progress_ratio() > 0.5:
		flip()
	
	if path_follow.get_progress_ratio() >= 1.0:
		despawn_customer()


func flip():
	customer_sprite.flip_h = true


func despawn_customer():
	SignalBus.emit_on_customer_despawn(self)
	queue_free()


func on_customer_wait_area_entered():
	movement_handler.movement_speed = 0
	#await get_tree().create_timer(3.0).timeout
	await SignalBus.on_trade_complete
	movement_handler.movement_speed = 300


## TODO: Randomize multiple numbers of products within order, 
##    i.e. 2 Potato vs 1 Tomato vs 2 Potato, 1 Tomato
#func add_random_order_to_mob():
	#var texture_paths = ["res://Assets/tomato_icon.png", "res://Assets/potato_icon.png"]	
	#var product_name = available_plants[randi_range(0, available_plants.size() - 1)]
	#var mob_name = name
	#var req = get_node("SellReq/Req")
	#for path in texture_paths:
		#if path.contains(product_name.to_lower()):
			#var texture = load(path)
			#req.set_texture(texture)
	#Global.orders_dict[mob_name] = {
				#"product": product_name,
				#"number": 1,
				#"order_completed": false
			#}
