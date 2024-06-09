extends Node


const ENTITY_CONTAINER : String = "entity_container"
const LEVEL_CONTAINER: String = "level_container"
const MANAGER_CONTAINER: String = "manager_container"
const UI_CONTAINER: String = "ui_container"
const PLANT_CONTAINER: String = "plant_container"


func get_plant_container() -> Node:
	return get_tree().get_first_node_in_group(PLANT_CONTAINER)


func get_entity_container() -> Node:
	return get_tree().get_first_node_in_group(ENTITY_CONTAINER)


func get_level_container() -> Node:
	return get_tree().get_first_node_in_group(LEVEL_CONTAINER)


func get_manager_container() -> Node:
	return get_tree().get_first_node_in_group(MANAGER_CONTAINER)


func get_ui_container() -> Node:
	return get_tree().get_first_node_in_group(UI_CONTAINER)


func get_random_time(timer_min: float, timer_max: float) -> float:
	return randf_range(timer_min, timer_max)
