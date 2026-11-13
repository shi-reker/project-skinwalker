extends Node
class_name ActorState

@export var state_name: StringName
signal switch_state(nextState:ActorState)

func enter(previous_state: StringName) -> void:
	pass

func exit(next_state: StringName) -> void:
	pass

func update_state(delta: float) -> void:
	pass
