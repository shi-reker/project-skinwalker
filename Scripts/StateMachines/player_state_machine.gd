extends StateMachine
class_name PlayerStateMachine

enum State {
	TRAVELING_HOME,
	HIDING,
	ENTERING_HOME,
	CAUGHT,
	SAFE_AT_HOME,
}

@export var initial_state: State = State.TRAVELING_HOME
var current_state_id: State = State.TRAVELING_HOME
