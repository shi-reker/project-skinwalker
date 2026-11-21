extends CharacterBody2D
class_name StalkerActor

@export var movement_component: MovementComponent
@onready var state_machine: StalkerStateMachine = $StateMachine
@export var stalker_definition: StalkerDefinition
@export var known_hints: Array[HintDefinition] = []
@export var deployed_detection_systems: Array[DetectionSystem] = []
@export var sprite:Sprite2D
@export var detection_component: DetectionComponent
@export var target:PlayerActor
#@export var navAgent:NavigationAgent2D

var distToTarget:float = 0
var is_player_detected: bool = false

func _ready() -> void:
	sprite.texture = stalker_definition.texture
	sprite.scale = Vector2(0.1, 0.1)

func _physics_process(delta: float) -> void:
	state_machine.update_current_state(delta)
	if !state_machine.current_state_id == state_machine.State.SEARCHING and target != null:
		distToTarget = global_position.distance_to(target.global_position)
		#print_debug(distToTarget)
		if distToTarget < 120:
			state_machine.change_state(state_machine.stateTable[state_machine.State.SURVEILING])
		elif distToTarget < 60:
			state_machine.change_state(state_machine.stateTable[state_machine.State.CAPTURING])

func _on_detection_range_entered(body: Node2D) -> void:
	if body is PlayerActor:
		state_machine.change_state(state_machine.stateTable[state_machine.State.PURSUING])

func _on_detection_range_exited(body: Node2D) -> void:
	if body is PlayerActor:
		state_machine.change_state(state_machine.stateTable[state_machine.State.SEARCHING])

func detected_player_entered_home():
	print("i see you :)")

func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	pass # Replace with function body.
