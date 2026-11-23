extends Node
class_name ActorState

@export var state_name: StringName
var actor: CharacterBody2D
var manager:StateMachine = null
var player_manager:PlayerStateMachine = null # for player states
var stalker_manager:StalkerStateMachine = null # for stalker states
var statesTable: Dictionary[int, ActorState]

@export var state_code: int
signal switch_state(nextState:ActorState)

func setup(actor_node: CharacterBody2D, inputStatesTable: Dictionary[int, ActorState]):
	actor = actor_node
	statesTable = inputStatesTable

func enter(previous_state: StringName) -> void:
	pass

func exit(next_state: StringName) -> void:
	pass

func update_state(delta: float) -> void:
	pass
