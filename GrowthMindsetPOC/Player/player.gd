class_name Player
extends CharacterBody2D

@onready var input_handler = $InputHandler as InputHandler
@onready var movement_handler = $MovementHandler as MovementHandler

@onready var cur = get_tree().root.get_node("SceneTree/GameLevel/Cursor")
@onready var farm_stand = get_tree().root.get_node("SceneTree/GameLevel/PathSpawner")
@onready var sell_area = farm_stand.get_node("CustomerSellArea")

var plant = Plant.new()
var in_sell_area = false


func _physics_process(_delta):
	movement_handler.handle_movement(self, input_handler.handle_movement())
	move_and_slide()


func _input(_event):
	if input_handler.handle_action_1_input():
		if !plant.is_plant_at_position() and cur.is_cursor_within_farm_plot():
			plant.create_plant(0)
	if input_handler.handle_action_2_input():
		if !plant.is_plant_at_position() and cur.is_cursor_within_farm_plot():
			plant.create_plant(1)
	if input_handler.handle_action_3_input():
		if plant.is_plant_at_position():
			plant.harvest()
	if input_handler.handle_action_4_input():
		if in_sell_area && sell_area.is_customer_in_sell_area():
			var customer_name = sell_area.get_customer_name_in_sell_area()
			trade(customer_name)


func trade(customer):
	var order = Global.orders_dict[customer]
	var product = order["product"]
	var num_ordered = order["number"]
	var inventory = plant.get_plants_dict()[product]["current"]
		
		
	if plant.get_plants_dict().has(product) and inventory["plants_on_hand"] >= order["number"]:
		inventory["plants_on_hand"] -= num_ordered
		inventory["seeds"] += 2
		order["order_completed"] = true
	else:
		# TODO: audio/visual indicator why trade failed
		print(str(product) + ": item not found in inventory.")
		


func _on_sell_area_body_entered(_body):
	in_sell_area = true # Replace with function body.


func _on_sell_area_body_exited(_body):
	in_sell_area = false
