extends Node2D
class_name MovementComponent

@export var movement_definition: MovementDefinition
@export var actor: CharacterBody2D
@export var navigator:NavigationAgent2D
var input_direction: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var target_velocity: Vector2 = Vector2.ZERO
var has_target_position: bool = false
var _debug_elapsed: float = 1.0
var _using_direct_fallback: bool = false

func _ready() -> void:
	if actor == null:
		actor = get_parent().get_parent() as CharacterBody2D
	if navigator != null and not navigator.velocity_computed.is_connected(_on_nav_agent_velocity_computed):
		navigator.velocity_computed.connect(_on_nav_agent_velocity_computed)

func move_with_input(direction: Vector2, delta: float) -> void:
	input_direction = direction.normalized()
	_apply_movement(input_direction, delta)

func move_to(destination: Vector2, delta: float) -> void:
	if actor == null or movement_definition == null:
		return
	if navigator == null:
		push_error("MovementComponent.move_to requires a NavigationAgent2D.")
		return

	target_position = destination
	has_target_position = true
	navigator.target_position = destination
	var distToTarget = actor.global_position.distance_to(destination)
	var next_path_position := navigator.get_next_path_position()
	var target_distance := actor.global_position.distance_to(destination)
	var navigation_finished := navigator.is_navigation_finished()

	_debug_elapsed += delta
	if _debug_elapsed >= 1.0:
		print_debug(
			"[MovementComponent] actor=", actor.name,
			" goal=", destination,
			" next=", next_path_position,
			" distance=", target_distance,
			" navigation_finished=", navigation_finished,
			" map_valid=", navigator.get_navigation_map().is_valid(),
			" velocity=", actor.velocity
		)
		_debug_elapsed = 0.0

	if is_target_reached():
		_using_direct_fallback = false
		stop_movement()
		at_range.emit(distToTarget)
		return

	if navigation_finished:
		if not _using_direct_fallback:
			print_debug(
				"[MovementComponent] No usable navigation path to ", destination,
				"; moving directly as a fallback."
			)
			_using_direct_fallback = true
		var direct_direction := actor.global_position.direction_to(destination)
		move_with_velocity(direct_direction * movement_definition.walk_speed)
		return

	_using_direct_fallback = false
	var desired_direction := actor.global_position.direction_to(next_path_position)
	if navigator.avoidance_enabled:
		navigator.velocity = desired_direction * movement_definition.walk_speed
	else:
		_apply_movement(desired_direction, delta)

func is_target_reached() -> bool:
	if actor == null or navigator == null or not has_target_position:
		return false
	var distance_to_target := actor.global_position.distance_to(target_position)
	return navigator.is_navigation_finished() and distance_to_target <= navigator.target_desired_distance

func stop_movement() -> void:
	if actor == null:
		return
	if navigator != null:
		navigator.velocity = Vector2.ZERO
	actor.velocity = Vector2.ZERO
	actor.move_and_slide()

func move_with_velocity(velocity: Vector2) -> void:
	if actor == null:
		return
	actor.velocity = velocity
	actor.move_and_slide()

func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	move_with_velocity(safe_velocity)

func _apply_movement(direction: Vector2, delta: float) -> void:
	if actor == null or movement_definition == null:
		return
	var target_speed := movement_definition.walk_speed if direction != Vector2.ZERO else 0.0
	target_velocity = direction * target_speed
	var rate := movement_definition.acceleration if direction != Vector2.ZERO else movement_definition.deceleration
	actor.velocity = actor.velocity.move_toward(target_velocity, rate * delta)
	actor.move_and_slide()
