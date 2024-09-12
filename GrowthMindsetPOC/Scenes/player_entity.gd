class_name PlayerEntity
extends CharacterBody2D

# Player handlers
@onready var input_handler = $HandlerContainer/InputHandler as InputHandler
@onready var movement_handler = $HandlerContainer/MovementHandler as MovementHandler
@onready var action_handler = $HandlerContainer/ActionHandler as ActionHandler

# Cursor entity and handlers
@onready var cursor = $CursorEntity as CursorEntity
@onready var cursor_movement_handler = $CursorEntity/HandlerContainer/CursorMovementHandler as CursorMovementHandler


func _ready():
	SignalBus.emit_on_player_ready(self)
	NodeExtensions.get_entity_container()


func _physics_process(_delta):
	movement_handler.handle_movement(self, input_handler.handle_movement())
	cursor_movement_handler.handle_cursor_position(self, input_handler.handle_movement(), cursor)
	move_and_slide()


func _input(_event):
	#if input_handler.handle_action_1_input() && \
		#cursor_action_handler.planting_enabled(cursor_action_handler.detect_overlapped_areas(cursor)):
		#action_handler.create_plant(0, cursor.global_position)
	#if input_handler.handle_action_2_input() && can_plant:
		#action_handler.create_plant(1, cursor.global_position)
	if input_handler.handle_action_3_input():
		print("action 3 pressed")
	if input_handler.handle_action_4_input():
		print("action 4 pressed")


#func is_within_farm_plot(is_within: bool) -> void:
	#within_plot = is_within

#func does_contain_plant(does_contain: bool) -> void:
	#contains_plant = does_contain


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
