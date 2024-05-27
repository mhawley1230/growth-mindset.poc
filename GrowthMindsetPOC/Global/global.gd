extends Node

@export var speed = 200

@onready var plant = Plant.new()
@onready var plants_ui = get_tree().root.get_node("SceneTree/UI/PlantsUI/MarginContainer/GridContainer")
@onready var seeds_ui = get_tree().root.get_node("SceneTree/UI/SeedsUI/MarginContainer/GridContainer")

var TILE_SIZE: int = 32
var orders_dict: Dictionary = {}
var mobs_dict = {
	"spawned": {
		"mob_a": 0
	}
}
# TODO: limit max number of grown plants vs. number of seeds to complete level
var plants_dict: Dictionary = {"Tomato":{"total":{"#_created": 0, "#_harvested": 0},"current": {"seeds": 4, "plants_on_hand": 0, "target_inventory": 5}},"Potato": {"total": {"#_created": 0, "#_harvested": 0},"current": {"seeds": 4, "plants_on_hand": 0, "target_inventory": 5}}}


func _process(_delta):
	for element in plants_ui.get_children():
		if element.name.contains("Label"):
			var n = element.name.split("L")[0]
			var held = plants_dict[n]["current"]["plants_on_hand"]
			var max_held = plants_dict[n]["current"]["target_inventory"]
			element.text = str(held) + " / " + str(max_held)
			
	for element in seeds_ui.get_children():
		if element.name.contains("Label"):
			var n = element.name.split("Seeds")[0]
			var held = plants_dict[n]["current"]["seeds"]
			var max_held = plants_dict[n]["current"]["target_inventory"]
			element.text = str(held) + " / " + str(max_held)

func round_to_dec(num, decimals):
	num = float(num)
	decimals = int(decimals)
	var sgn = 1
	if num < 0:
			sgn = -1
			num = abs(num)
			pass
	var num_fraction = num - int(num) 
	var num_dec = round(num_fraction * pow(10.0, decimals)) / pow(10.0, decimals)
	var round_num = sgn*(int(num) + num_dec)
	return round_num
