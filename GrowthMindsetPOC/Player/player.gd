extends CharacterBody2D

@export var move_speed: float = 100
@onready var input_direction: Vector2
@onready var cur = get_tree().root.get_node("SceneTree/GameLevel/Cursor")
@onready var farm_stand = get_tree().root.get_node("SceneTree/GameLevel/Farm")
@onready var sell_area = farm_stand.get_node("SellArea")
@onready var plants_scripts = preload("res://Level/plants.gd")
#@onready var mob_scripts = preload("res://Mobs/mob_a.gd")

var p
var cur_pos: Vector2
var positions_arr: Array
var mob

#func _ready():
	#var p = plants_scripts.new()
	#var mob = mob_scripts.new()

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
		if sell_area.is_player_in_sell_area() && sell_area.is_customer_in_sell_area()["can_sell"]:
			trade(sell_area.is_customer_in_sell_area()["mob_name"])
			
func trade(customer):
	print("Ready to trade with " + customer)
	print(Global.orders_dict[customer])
	#for item in Global.orders_dict[customer]:
	var product = Global.orders_dict[customer]["product"]
	print(product)
	var number = Global.orders_dict[customer]["number"]
	var inventory = Plants.get_plants_dict()[product]["current"]["plants_on_hand"]
		#if Plants.get_plants_dict()[item]["current"]["plants_on_hand"] >= Global.orders_dict[customer]["number"]:
	print("Customer " + customer + " wants " + str(number) + " of " + product)
	if Plants.get_plants_dict().has(product):
		print("Inventory contains " + str(inventory) + " of " + product)
			#Plants.get_plants_dict()[item] -= Global.orders_dict[customer]["number"]
			#Plants.get_plants_dict()[item]["current"]["seeds"] += 2
			#print("trade complete")
			#emit_signal("trade_complete")
	
