extends Node
class_name MovementComponent

@export var movement_definition: MovementDefinition
@export var actor: CharacterBody2D
var input_direction: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var target_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	if actor == null:
		actor = get_parent().get_parent() as CharacterBody2D

func move_with_input(direction: Vector2, delta: float) -> void:
	input_direction = direction.normalized()
	_apply_movement(input_direction, delta)

func move_to(destination: Vector2, delta: float) -> void:
	if actor == null or movement_definition == null:
		return
	target_position = destination
	var direction := actor.global_position.direction_to(destination)
	if actor.global_position.is_equal_approx(destination):
		direction = Vector2.ZERO
	_apply_movement(direction, delta)

func stop_movement() -> void:
	if actor == null:
		return
	actor.velocity = Vector2.ZERO
	actor.move_and_slide()

func _apply_movement(direction: Vector2, delta: float) -> void:
	if actor == null or movement_definition == null:
		return
	var target_speed := movement_definition.walk_speed if direction != Vector2.ZERO else 0.0
	target_velocity = direction * target_speed
	var rate := movement_definition.acceleration if direction != Vector2.ZERO else movement_definition.deceleration
	actor.velocity = actor.velocity.move_toward(target_velocity, rate * delta)
	actor.move_and_slide()
