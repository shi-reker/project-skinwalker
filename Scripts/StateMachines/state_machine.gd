extends Node
class_name StateMachine

@export var current_state: ActorState
@export var available_states: Array[ActorState] = []

func change_state(next_state: ActorState) -> void:
	if next_state == current_state:
		return

func update_current_state(delta: float) -> void:
	pass
