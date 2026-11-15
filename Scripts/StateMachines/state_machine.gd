extends Node
class_name StateMachine

@export var initial_state: ActorState
@export var current_state: ActorState
@export var available_states: Array[ActorState] = []
var actor: CharacterBody2D

func setup(actor_node: CharacterBody2D) -> void:
	actor = actor_node
	for child: Node in get_children():
		var state := child as ActorState
		if state == null:
			continue
		state.switch_state.connect(change_state)
		state.setup(actor)

func change_state(next_state: ActorState) -> void:
	if next_state == current_state:
		return
	current_state = next_state

func update_current_state(delta: float) -> void:
	pass
