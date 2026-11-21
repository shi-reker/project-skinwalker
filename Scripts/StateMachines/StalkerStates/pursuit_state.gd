extends ActorState
class_name PursuitState

@export var movementComponen:MovementComponent
@export var navigator:NavigationAgent2D

var target:Vector2

func update_state(delta: float) -> void:
	navigator.target_position = actor.global_position
	var nextPathPos = navigator.get_next_path_position()
	var newVelocity = actor.global_position.direction_to(nextPathPos) * movementComponen.movement_definition.walk_speed
	
	if navigator.is_navigation_finished():
		switch_state.emit(manager.available_states[2])
	
	if navigator.avoidance_enabled:
		navigator.set_velocity_forced(newVelocity)
	else:
		_on_nav_agent_velocity_computed(newVelocity)
	movementComponen.move_to(target, delta)

func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	pass # Replace with function body.
