extends StateMachine
class_name StalkerStateMachine

enum State {
	SEARCHING,
	INVESTIGATING_HINT,
	PURSUING,
	DEPLOYING_SURVEILLANCE,
	TARGET_LOST,
}

@export var pursuitState:PursuitState
@export var investigateState:InvestigateState
@export var surveilState:SurveilState
@export var searchingState:SearchingState
@export var lostState:LostState

@export var initial_state: State = State.SEARCHING
var current_state_id: State = State.SEARCHING

func update_current_state(delta: float) -> void:
	current_state.update_state(delta)
