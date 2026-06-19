class_name Player
extends CharacterBody2D

@onready var input_component: InputComponent = %InputComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var action_component: ActionComponent = %ActionComponent
#@onready var planting_component: PlantingComponent = %PlantingComponent
@onready var harvesting_component: HarvestingComponent = %HarvestingComponent
@onready var trading_component: TradingComponent = %TradingComponent
@onready var cursor: Cursor = %Cursor


#func _ready() -> void:
	#NodeExtensions.get_entity_container()
	#SignalBus.emit_on_player_ready(self)
	##cursor = Refs.cursor_scene.instantiate()
#
#
#func _physics_process(_delta: float) -> void:
	#movement_component.handle_movement(self, input_component.handle_movement())
	#move_and_slide()
	#cursor.cursor_position_component.handle_cursor_position(
			#self, cursor, input_component.handle_movement())
#
#
#func _input(_event: InputEvent) -> void:
	#if input_component.handle_action_1_input():
		#if action_component.is_planting_enabled(
				##action_component.detect_overlapped_areas(cursor)):
			##planting_component.create_plant(0, cursor.global_position)
##
	#if input_component.handle_action_2_input():
		#harvesting_component.harvest_plant(
				#action_component.detect_overlapped_areas(cursor))
	
	#if input_component.handle_action_3_input():
		#if action_component.trading_enabled && action_component.customer_in_trade_area:
			#action_component.trade(action_component.get_customer_order())
		
	#if input_component.handle_action_4_input():
		#print("action 4 pressed")
