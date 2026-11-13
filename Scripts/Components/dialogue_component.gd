extends Node
class_name DialogueComponent

@export var dialogue_definition: DialogueDefinition
var current_line_index: int = 0
var is_dialogue_active: bool = false

func start_dialogue() -> void:
	pass

func advance_dialogue() -> void:
	pass

func end_dialogue() -> void:
	pass
