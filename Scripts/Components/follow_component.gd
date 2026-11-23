extends Node
class_name FollowComponent

@export var actor: CharacterBody2D
@export var movement_component: MovementComponent
@export var target: Node2D
@export var follow_distance: float = 60.0
@export var stop_distance: float = 40.0

var is_following: bool = false

func start_following(new_target: Node2D) -> void:
	target = new_target
	is_following = true

func stop_following() -> void:
	is_following = false
	target = null
	if movement_component:
		movement_component.stop_movement()

func _physics_process(delta: float) -> void:
	if not is_following or target == null or actor == null or movement_component == null:
		return

	var dist := actor.global_position.distance_to(target.global_position)

	if dist > follow_distance:
		movement_component.move_to(target.global_position, delta)
	elif dist < stop_distance:
		movement_component.stop_movement()
