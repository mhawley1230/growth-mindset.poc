class_name CustomerSpawnerComponent
extends Node

# Level-owned customer spawn authority (see NOTES.txt "DECISION: customer
# behavior"). It instantiates Path scenes (each Path carries one customer along
# a PathFollow2D); per-customer behavior lives in components on the customer
# entity, not here. Fully guarded: a no-op until a path_scene is assigned and
# setup() is called by the level, so it is safe to leave unwired.

signal customer_spawned(path: Node)

@export var path_scene: PackedScene
@export var spawn_interval: float = 5.0
@export var auto_spawn: bool = false

var _container: Node = null
var _timer: float = 0.0

## Called by the level. container is the node spawned paths are added under.
func setup(container: Node) -> void:
	_container = container

func _process(delta: float) -> void:
	if not auto_spawn or path_scene == null or _container == null:
		return
	_timer += delta
	if _timer >= spawn_interval:
		_timer = 0.0
		spawn()

func spawn() -> void:
	if path_scene == null or _container == null:
		return
	var path: Node = path_scene.instantiate()
	_container.add_child(path)
	customer_spawned.emit(path)
