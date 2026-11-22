extends CharacterBody2D
class_name StalkerActor

@export var stalker_definition: StalkerDefinition
@onready var movement_component: MovementComponent = $Components/MovementComponent
@onready var raycast_detection_component: RaycastDetectionComponent = $Components/RaycastDetectionComponent
@onready var state_machine: StalkerStateMachine = $StateMachine
@export var known_hints: Array[HintDefinition] = []
@export var deployed_detection_systems: Array[DetectionSystem] = []
@export var sprite: Sprite2D
@export var detectionRange: Area2D

var target
var distToTarget: float
var is_player_detected: bool = false


func _ready() -> void:
	add_to_group("stalker")
	if stalker_definition != null and stalker_definition.texture != null:
		sprite.texture = stalker_definition.texture
	sprite.scale = Vector2(0.1, 0.1)

	state_machine.setup(self)


func _physics_process(delta: float) -> void:
	state_machine.update_current_state(delta)

	if state_machine.current_state_id == state_machine.State.SEARCHING or target == null:
		return

	# Jika player sedang disguise, jangan ubah state ke CAPTURE
	if target is PlayerActor and target.is_disguised:
		return

	distToTarget = global_position.distance_to(target.global_position)

	# URUTAN BENAR: cek jarak terdekat dulu
	if distToTarget < 60:
		state_machine.change_state(state_machine.stateTable[state_machine.State.CAPTURING])
	elif distToTarget < 120:
		state_machine.change_state(state_machine.stateTable[state_machine.State.SURVEILING])


func _on_detection_range_entered(body: Node2D) -> void:
	# Abaikan player jika sedang disguise
	if body is PlayerActor and body.is_disguised:
		return

	target = body
	state_machine.change_state(state_machine.stateTable[state_machine.State.PURSUING])


func _on_detection_range_exited(body: Node2D) -> void:
	if body == target:
		target = null
	state_machine.change_state(state_machine.stateTable[state_machine.State.SEARCHING])


func detected_player_entered_home() -> void:
	print("i see you :)")
