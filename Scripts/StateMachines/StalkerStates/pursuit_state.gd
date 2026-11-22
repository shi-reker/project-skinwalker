extends ActorState
class_name PursuitState

var target: PlayerActor

func enter(previous_state: StringName) -> void:
	pass

func exit(next_state: StringName) -> void:
	pass

func update_state(delta: float) -> void:
	var stalker := actor as StalkerActor
	if stalker != null:
		stalker.movement_component.move_to(target.global_position, delta)

func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	if actor is not StalkerActor:
		return
	actor.movement_component.move_with_velocity(safe_velocity)
