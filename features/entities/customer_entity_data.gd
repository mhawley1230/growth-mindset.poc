class_name CustomerEntityData
extends Resource

## Data describing one kind of customer the level can spawn (see
## NOTES.txt "DECISION: customer behavior"). EntitySpawnController picks one
## of these at random each time PathController's spawn timer fires, then
## instantiates `scene` and hands it to PathController to place on the path.
##
## Named CustomerEntityData (not CustomerEntity) to avoid colliding with the
## existing `CustomerEntity` class_name already used by the CharacterBody2D
## script at features/entities/customer_entity.gd.
@export var scene: PackedScene
@export var customer_name: String = ""
@export var traits: Array[String] = []
@export var description: String = ""
