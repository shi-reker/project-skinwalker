extends StateMachine
class_name StalkerStateMachine

enum State {
	SEARCHING,
	INVESTIGATING_HINT,
	PURSUING,
	DEPLOYING_SURVEILLANCE,
	TARGET_LOST,
}

@export var initial_state: State = State.SEARCHING
var current_state_id: State = State.SEARCHING
