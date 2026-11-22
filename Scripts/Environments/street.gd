extends Node2D
class_name Street

@export var street_name: String = ""
@export var connected_street: Array[Street] = []

func _ready() -> void:
	EnvironmentManager.add_street(self)
