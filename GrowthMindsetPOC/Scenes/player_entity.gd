class_name PlayerEntity
extends CharacterBody2D

@onready var input_handler = $HandlerContainer/InputHandler as InputHandler
@onready var movement_handler = $HandlerContainer/MovementHandler as MovementHandler
@onready var cursor_handler = $HandlerContainer/CursorHandler as CursorHandler
@onready var action_handler = $HandlerContainer/ActionHandler as ActionHandler
@onready var cursor = $CursorEntity as CursorEntity

var can_plant = false

func _ready():
	SignalBus.emit_on_player_ready(self)
	NodeExtensions.get_entity_container()
	SignalBus.on_is_within_farm_plot.connect(on_is_within_farm_plot)


func _physics_process(_delta):
	movement_handler.handle_movement(self, input_handler.handle_movement())
	cursor_handler.handle_cursor_position(self, input_handler.handle_movement(), cursor)
	move_and_slide()


func _input(_event):
	if input_handler.handle_action_1_input() && can_plant:
		action_handler.create_plant(0, cursor.global_position)
	if input_handler.handle_action_2_input() && can_plant:
		action_handler.create_plant(1, cursor.global_position)
	if input_handler.handle_action_3_input():
		print("action 3 pressed")
	if input_handler.handle_action_4_input():
		print("action 4 pressed")


func on_is_within_farm_plot(is_within: bool) -> bool:
	can_plant = is_within
	return can_plant


#func trade(customer):
	#var order = Global.orders_dict[customer]
	#var product = order["product"]
	#var num_ordered = order["number"]
	#var inventory = plant.get_plants_dict()[product]["current"]
		#
		#
	#if plant.get_plants_dict().has(product) and inventory["plants_on_hand"] >= order["number"]:
		#inventory["plants_on_hand"] -= num_ordered
		#inventory["seeds"] += 2
		#order["order_completed"] = true
	#else:
		## TODO: audio/visual indicator why trade failed
		#print(str(product) + ": item not found in inventory.")
		


#func _on_sell_area_body_entered(_body):
	#in_sell_area = true
#
#
#func _on_sell_area_body_exited(_body):
	#in_sell_area = false
