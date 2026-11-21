extends ActorState
class_name PursuitState

@export var movementComponen:MovementComponent

var target:Vector2

func update_state(delta: float) -> void:
	movementComponen.move_to(target, delta)
