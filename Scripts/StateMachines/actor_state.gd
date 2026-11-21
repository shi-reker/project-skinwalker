extends Node
class_name ActorState

@export var state_name: StringName

var actor: CharacterBody2D
var manager:StateMachine

@export var state_code: int
signal switch_state(nextState:ActorState)

func setup(actor_node: CharacterBody2D):
	actor = actor_node

func enter(previous_state: StringName) -> void:
	pass

func exit(next_state: StringName) -> void:
	pass

func update_state(delta: float) -> void:
	pass
