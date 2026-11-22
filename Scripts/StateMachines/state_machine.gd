extends Node
class_name StateMachine

@export var initial_state: ActorState
@export var current_state: ActorState
@export var available_states: Array[ActorState] = []
var actor: CharacterBody2D

signal on_state_change(code: int)


func setup(actor_node: CharacterBody2D) -> void:
	actor = actor_node
	for child: Node in get_children():
		var state := child as ActorState
		if state == null:
			continue
		if not state.switch_state.is_connected(change_state):
			state.switch_state.connect(change_state)
		state.setup(actor)


func change_state(next_state: ActorState) -> void:
	if next_state == current_state:
		return
	if current_state:
		current_state.exit(next_state.state_name)
	current_state = next_state
	if current_state:
		current_state.enter(current_state.state_name)
		on_state_change.emit(current_state.state_code)


func update_current_state(delta: float) -> void:
	if current_state:
		current_state.update_state(delta)
