extends CharacterBody2D
class_name StalkerActor

@export var stalker_definition: StalkerDefinition
@onready var movement_component: MovementComponent = $Components/MovementComponent
@onready var raycast_detection_component: RaycastDetectionComponent = $Components/RaycastDetectionComponent
@onready var state_machine: StalkerStateMachine = $StateMachine
@export var known_hints: Array[HintDefinition] = []
@export var deployed_detection_systems: Array[DetectionSystem] = []
@export var sprite:Sprite2D
@export var detectionRange:Area2D

var target:PlayerActor

func _ready() -> void:
	sprite.texture = stalker_definition.texture
	sprite.scale = Vector2(0.1, 0.1)

func _physics_process(delta: float) -> void:
	state_machine.update_current_state(delta)
	if !state_machine.current_state_id == state_machine.State.SEARCHING:
		var dist = global_position.distance_to(target.global_position)
		if dist < 120:
			state_machine.change_state(state_machine.stateTable[state_machine.State.SURVEILING])
		elif dist < 60:
			state_machine.change_state(state_machine.stateTable[state_machine.State.CAPTURING])

func _on_detection_range_entered(body: PlayerActor) -> void:
	state_machine.change_state(state_machine.stateTable[state_machine.State.PURSUING])
	target = body

func _on_detection_range_exited(body: PlayerActor) -> void:
	state_machine.change_state(state_machine.stateTable[state_machine.State.SEARCHING])
