extends Node
class_name StateMachine

@export var initial_state: ActorState
@export var current_state: ActorState
@export var available_states: Array[ActorState] = []
@export var actor: CharacterBody2D

var stateTable:Dictionary[int, ActorState]

func setup(actor_node: CharacterBody2D):
	actor = actor_node
	for child: Node in get_children():
		var state := child as ActorState
		if state == null:
			return
		setup_state(state)

func setup_state(state: ActorState):
	state.switch_state.connect(change_state)
	state.setup(actor, stateTable)
	state.manager = self
   
signal on_state_change(code:int)

func change_state(next_state: ActorState):
	if next_state == current_state:
		return
	current_state.exit(next_state.state_name)
	current_state = next_state
	current_state.enter(current_state.state_name)
	on_state_change.emit(current_state.state_code)

func update_current_state(delta: float) -> void:
	current_state.update_state(delta)
