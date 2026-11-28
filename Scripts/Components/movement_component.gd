
extends Node2D
class_name MovementComponent


# =========================================================
# References
# =========================================================

@export_group("Movement")

@export var movement_definition: MovementDefinition
@export var actor: CharacterBody2D
@export var navigator: NavigationAgent2D


# =========================================================
# Movement Data
# =========================================================

var input_direction: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var target_velocity: Vector2 = Vector2.ZERO

var has_target_position: bool = false

var _last_direction: Vector2 = Vector2.ZERO
var _debug_elapsed: float = 0.0


# =========================================================
# Signals
# =========================================================

signal at_range(distance: float)
signal direction_changed(new_direction: Vector2)


# =========================================================
# Initialization
# =========================================================

func setup(
	_actor: CharacterBody2D,
	_movement_def: MovementDefinition = null
) -> void:
	actor = _actor

	if _movement_def != null:
		movement_definition = _movement_def


func _ready() -> void:
	# Fallback if actor wasn't assigned through setup().
	if actor == null:
		actor = get_parent().get_parent() as CharacterBody2D

	if navigator != null:
		if not navigator.velocity_computed.is_connected(
			_on_nav_agent_velocity_computed
		):
			navigator.velocity_computed.connect(
				_on_nav_agent_velocity_computed
			)


# =========================================================
# Manual Movement
# =========================================================

func move_with_input(direction: Vector2, delta: float) -> void:
	if movement_definition == null:
		return

	move_in_direction(
		direction,
		delta,
		movement_definition.walk_speed
	)


func move_in_direction(
	direction: Vector2,
	delta: float,
	speed: float
) -> void:
	input_direction = direction.normalized()
	_apply_movement(input_direction, delta, speed)


# =========================================================
# Navigation Movement
# =========================================================

func move_to(
	destination: Vector2,
	delta: float,
	speed: float = -1.0
) -> void:
	if actor == null or movement_definition == null:
		return

	if navigator == null:
		push_error("MovementComponent: NavigationAgent2D is missing.")
		return

	var movement_speed := (
		movement_definition.walk_speed
		if speed < 0.0
		else speed
	)

	if (
		not has_target_position
		or target_position.distance_squared_to(destination) > 1.0
	):
		target_position = destination
		has_target_position = true
		navigator.target_position = destination

	var distance_to_target := actor.global_position.distance_to(
		target_position
	)

	_debug_navigation(delta, destination, distance_to_target)

	if is_target_reached():
		stop_movement()
		at_range.emit(distance_to_target)
		return

	if navigator.is_navigation_finished():
		stop_movement()
		return

	var next_path_position := navigator.get_next_path_position()

	var desired_direction := actor.global_position.direction_to(
		next_path_position
	)

	var desired_velocity := desired_direction * movement_speed

	if navigator.avoidance_enabled:
		navigator.velocity = desired_velocity
	else:
		_apply_movement(
			desired_direction,
			delta,
			movement_speed
		)


# =========================================================
# Target Checking
# =========================================================

func is_target_reached(min_distance: float = 0.0) -> bool:
	if actor == null or navigator == null or not has_target_position:
		return false

	if min_distance <= 0.0:
		min_distance = navigator.target_desired_distance

	var distance_to_target := actor.global_position.distance_to(
		target_position
	)

	return (
		navigator.is_navigation_finished()
		and distance_to_target <= min_distance
	)


func clear_target() -> void:
	has_target_position = false
	target_position = Vector2.ZERO

	if navigator != null:
		navigator.target_position = (
			actor.global_position
			if actor != null
			else Vector2.ZERO
		)


# =========================================================
# Stop Movement
# =========================================================

func stop_movement() -> void:
	if actor == null:
		return

	if navigator != null:
		navigator.velocity = Vector2.ZERO

	actor.velocity = Vector2.ZERO

	target_velocity = Vector2.ZERO
	input_direction = Vector2.ZERO

	_emit_direction(Vector2.ZERO)


# =========================================================
# Velocity Movement
# =========================================================

func move_with_velocity(velocity: Vector2) -> void:
	if actor == null:
		return

	actor.velocity = velocity
	actor.move_and_slide()

	_emit_direction(velocity.normalized())


func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	if actor == null:
		return

	actor.velocity = safe_velocity
	actor.move_and_slide()

	_emit_direction(safe_velocity.normalized())


# =========================================================
# Internal Movement
# =========================================================

func _apply_movement(
	direction: Vector2,
	delta: float,
	speed: float
) -> void:
	if actor == null or movement_definition == null:
		return

	var moving := direction != Vector2.ZERO
	target_velocity = direction * speed

	var acceleration_rate := (
		movement_definition.acceleration
		if moving
		else movement_definition.deceleration
	)

	print("Actor: ", actor.name)
	print("Current velocity: ", actor.velocity)
	print("Target velocity: ", target_velocity)
	print("Acceleration: ", acceleration_rate)
	print("Delta: ", delta)

	actor.velocity = actor.velocity.move_toward(
		target_velocity,
		acceleration_rate * delta
	)

	print("New velocity: ", actor.velocity)

	actor.move_and_slide()

	_emit_direction(direction)


# =========================================================
# Direction Updates
# =========================================================

func _emit_direction(direction: Vector2) -> void:
	if direction == _last_direction:
		return

	_last_direction = direction
	direction_changed.emit(direction)


# =========================================================
# Debugging
# =========================================================

func _debug_navigation(
	delta: float,
	destination: Vector2,
	distance: float
) -> void:
	_debug_elapsed += delta

	if _debug_elapsed < 1.0:
		return

	_debug_elapsed = 0.0

	print_debug(
		"[MovementComponent] actor=", actor.name,
		" goal=", destination,
		" distance=", distance,
		" navigation_finished=", navigator.is_navigation_finished(),
		" map_valid=", navigator.get_navigation_map().is_valid(),
		" velocity=", actor.velocity
	)
