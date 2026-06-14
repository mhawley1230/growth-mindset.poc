class_name Player
extends CharacterBody2D

@onready var input_handler: InputHandlerComponent = %InputHandlerComponent
@onready var movement_handler: MovementHandlerComponent = %MovementHandlerComponent
@onready var action_handler: ActionHandlerComponent = %ActionHandlerComponent
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
	#movement_handler.handle_movement(self, input_handler.handle_movement())
	#move_and_slide()
	#cursor.cursor_position_handler.handle_cursor_position(
			#self, cursor, input_handler.handle_movement())
#
#
#func _input(_event: InputEvent) -> void:
	#if input_handler.handle_action_1_input():
		#if action_handler.is_planting_enabled(
				##action_handler.detect_overlapped_areas(cursor)):
			##planting_component.create_plant(0, cursor.global_position)
##
	#if input_handler.handle_action_2_input():
		#harvesting_component.harvest_plant(
				#action_handler.detect_overlapped_areas(cursor))
	
	#if input_handler.handle_action_3_input():
		#if action_handler.trading_enabled && action_handler.customer_in_trade_area:
			#action_handler.trade(action_handler.get_customer_order())
		
	#if input_handler.handle_action_4_input():
		#print("action 4 pressed")
