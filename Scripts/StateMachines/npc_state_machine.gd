
extends StateMachine
class_name NPCStateMachine

enum State {
	IDLE,
	WANDERING,
	INTERACTING,
	INVESTIGATING,
}

var current_state_id: State = State.IDLE
