class_name CustomerQueue
extends Node2D

# Local signal replaces the old global SignalBus emit.
signal customer_arrived(customer: Node)

## Connect this to the queue's WaitArea body_entered in the scene (or via the
## level wiring). Emits a local signal when a customer reaches the queue.
func _on_wait_area_body_entered(body: Node) -> void:
	if body.is_in_group("customer"):
		customer_arrived.emit(body)
