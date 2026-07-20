class_name CustomerEntity
extends CharacterBody2D

@export var customer_order_component: CustomerOrderComponent

## Returns this customer's current order, keyed by product name.
func get_order() -> Dictionary:
	print(customer_order_component.get_order())
	if customer_order_component == null:
		return {}
	return customer_order_component.get_order()
