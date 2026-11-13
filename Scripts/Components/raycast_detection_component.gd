extends Node2D
class_name RaycastDetectionComponent

@export var detection_definition: DetectionDefinition
@onready var sight_ray: RayCast2D = $SightRay
@export var detected_target: Node2D
var is_target_visible: bool = false

func check_line_of_sight(target: Node2D) -> void:
	pass

func clear_detected_target() -> void:
	pass
