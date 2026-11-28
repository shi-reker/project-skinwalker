extends Node
class_name FollowComponent

@export var actor: CharacterBody2D
@export var movement_component: MovementComponent
@export var target: Node2D
@export var follow_distance: float = 60.0
@export var stop_distance: float = 40.0
var is_following: bool = false

func start_following(_actor: CharacterBody2D, _movement: MovementComponent, new_target: Node2D) -> void:
	target = new_target
	is_following = true
	actor = _actor
	movement_component = _movement
	print_debug("START FOLLOWING: ", actor, movement_component, target, is_following)

func stop_following() -> void:
	print_debug("STOP FOLLOWING: ", actor, movement_component, target, is_following)
	is_following = false
	target = null
	if movement_component:
		movement_component.stop_movement()

func _physics_process(delta: float) -> void:
	
	if target == null or actor == null or movement_component == null:
		return
	if !is_following:
		return	
	var dist := actor.global_position.distance_to(target.global_position)

	if dist > follow_distance:
		movement_component.move_to(target.global_position, delta)
	elif dist < stop_distance:
		movement_component.stop_movement()
