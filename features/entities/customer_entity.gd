class_name CustomerEntity
extends CharacterBody2D

@export var customer_order_component: CustomerOrderComponent

## Returns this customer's current order, keyed by product name.
func get_order() -> Dictionary[String, int]:
	if customer_order_component == null:
		return {}
	return customer_order_component.get_order()
