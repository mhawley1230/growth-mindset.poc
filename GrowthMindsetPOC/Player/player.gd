extends CharacterBody2D

class_name Player

@export var move_speed: float = 100
@onready var input_direction: Vector2
@onready var cur = get_tree().root.get_node("SceneTree/GameLevel/Cursor")
@onready var farm_stand = get_tree().root.get_node("SceneTree/GameLevel/Farm")
@onready var sell_area = farm_stand.get_node("SellArea")
@onready var plants_scripts = preload("res://Level/plants.gd")

var p
var cur_pos: Vector2
var positions_arr: Array
var mob

func _process(_delta):
	move()
	move_and_slide()
	
func move():
	input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	velocity = input_direction.normalized() * move_speed
	
	return input_direction
	
func _input(_event):
	if Input.is_action_just_pressed("action_1"):
		if !Plants.is_plant_at_position() and cur.is_cursor_within_farm_plot():
			Plants.create_plant(0)
	if Input.is_action_just_pressed("action_2"):
		if !Plants.is_plant_at_position() and cur.is_cursor_within_farm_plot():
			Plants.create_plant(1)
	if Input.is_action_just_pressed("action_3"):
		if Plants.is_plant_at_position():
			Plants.harvest()
	if Input.is_action_just_pressed("action_4"):
		if sell_area.is_player_in_sell_area() && sell_area.is_customer_in_sell_area():
			var customer_name = sell_area.get_customer_name_in_sell_area()
			trade(customer_name)
			
			if Global.orders_dict[customer_name]["order_completed"]:
				Global.continue_queue()
			
func trade(customer):
	var order = Global.orders_dict[customer]
	var product = order["product"]
	var num_ordered = order["number"]
	var inventory = Plants.get_plants_dict()[product]["current"]
		
		
	if Plants.get_plants_dict().has(product) and inventory["plants_on_hand"] >= order["number"]:
		inventory["plants_on_hand"] -= num_ordered
		inventory["seeds"] += 2
		order["order_completed"] = true
	else:
		# TODO: audio/visual indicator why trade failed
		print(str(product) + ": item not found in inventory.")
			
