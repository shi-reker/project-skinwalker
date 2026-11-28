
extends CharacterBody2D
class_name StalkerActor


# =========================================================
# References
# =========================================================

@export_group("Components")

@export var movement_component: MovementComponent
@export var stalker_definition: StalkerDefinition
@export var animation: AnimationComponent
@export var sprite: Sprite2D
@export var detection_component: DetectionComponent

@onready var state_machine: StalkerStateMachine = $StateMachine


# =========================================================
# AI Data
# =========================================================

var target: PlayerActor

var last_known_position: Vector2 = Vector2.ZERO
var has_last_known_position: bool = false

var is_player_detected: bool = false


# =========================================================
# Environment Data
# =========================================================

@export_group("Environment")

@export var known_hints: Array[HintDefinition] = []

var hints: EnvironmentManager.HomeHints = EnvironmentManager.HomeHints.new()


# =========================================================
# Movement Status
# =========================================================

var is_immobilized: bool = false
var _cached_move_speed: float = 0.0


# =========================================================
# Initialization
# =========================================================

func _ready() -> void:
	add_to_group("stalker")

	_initialize_visuals()
	_initialize_movement()
	_initialize_state_machine()
	_initialize_detection()
	_connect_signals()


func _initialize_visuals() -> void:
	if stalker_definition == null:
		push_error("StalkerActor: StalkerDefinition is missing.")
		return

	if stalker_definition.frames != null:
		if animation == null:
			push_error("StalkerActor: AnimationComponent is missing.")
			return

		animation.sprite_frames = stalker_definition.frames

	elif stalker_definition.texture != null:
		if sprite == null:
			push_error("StalkerActor: Sprite2D is missing.")
			return

		sprite.texture = stalker_definition.texture

	else:
		push_error(
			"StalkerActor: No visuals assigned to NPC definition: "
			+ stalker_definition.display_name
		)
		return

	if sprite != null:
		sprite.scale = Vector2(0.1, 0.1)


func _initialize_movement() -> void:
	if movement_component == null:
		push_error("StalkerActor: MovementComponent is missing.")
		return

	movement_component.setup(self)


func _initialize_state_machine() -> void:
	if state_machine == null:
		push_error("StalkerActor: StateMachine is missing.")
		return

	state_machine.setup(self)


func _initialize_detection() -> void:
	if detection_component == null:
		push_error("StalkerActor: DetectionComponent is missing.")
		return

	detection_component.setup(self)


# =========================================================
# Signal Connections
# =========================================================

func _connect_signals() -> void:
	if movement_component != null and animation != null:
		if not movement_component.direction_changed.is_connected(
			animation._on_movement_direction_changed
		):
			movement_component.direction_changed.connect(
				animation._on_movement_direction_changed
			)

	if detection_component != null and state_machine != null:
		if not detection_component.player_detected.is_connected(
			state_machine._on_detected
		):
			detection_component.player_detected.connect(
				state_machine._on_detected
			)


# =========================================================
# Immobilization
# =========================================================

func set_immobilized(value: bool) -> void:
	if is_immobilized == value:
		return

	if movement_component == null:
		return

	var movement_definition := movement_component.movement_definition

	if movement_definition == null:
		return

	if value:
		_cached_move_speed = movement_definition.walk_speed
		movement_definition.walk_speed = 0.0
	else:
		movement_definition.walk_speed = _cached_move_speed

	is_immobilized = value


func _on_immobilized(state: bool) -> void:
	set_immobilized(state)


# =========================================================
# Environment Hints
# =========================================================

func add_hint() -> void:
	hints = EnvironmentManager.HomeHints.new()
	hints.is_color_guessed = true

	if is_instance_valid(EnvironmentManager.home_node):
		hints = EnvironmentManager.reveal_hints(hints)

func _physics_process(_delta: float) -> void:
	print(
		"[StalkerActor] State: ",
		state_machine.current_state.name
	)
