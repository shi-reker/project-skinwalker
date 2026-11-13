extends Area2D
class_name DetectionSystem

@export var detection_definition: DetectionDefinition
@export var source_hint: HintDefinition
@export var detected_target: Node2D
var is_active: bool = false

func detect_target(target: Node2D) -> void:
	pass

func clear_detected_target() -> void:
	pass
