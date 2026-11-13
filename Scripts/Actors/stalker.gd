extends CharacterBody2D
class_name StalkerActor

@export var stalker_definition: StalkerDefinition
@onready var movement_component: MovementComponent = $Components/MovementComponent
@onready var raycast_detection_component: RaycastDetectionComponent = $Components/RaycastDetectionComponent
@onready var state_machine: StalkerStateMachine = $StateMachine
@export var known_hints: Array[HintDefinition] = []
@export var deployed_detection_systems: Array[DetectionSystem] = []
@export var sprite:Sprite2D

func _ready() -> void:
	sprite.texture = stalker_definition.texture
