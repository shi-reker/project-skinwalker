extends StateMachine
class_name StalkerStateMachine

enum State {
	SEARCHING,
	INVESTIGATING_HINT,
	PURSUING,
	DEPLOYING_SURVEILLANCE,
	TARGET_LOST,
}

@export var searchingState:SearchingState
@export var investigateState:InvestigateState
@export var pursuitState:PursuitState
@export var surveilState:SurveilState
@export var lostState:LostState

@export var initial_state: State = State.SEARCHING
var current_state_id: State = State.SEARCHING

var stateTable:Dictionary[State, ActorState]

func _ready() -> void:
	stateTable = {
		State.SEARCHING: searchingState,
		State.INVESTIGATING_HINT: investigateState,
		State.PURSUING: pursuitState,
		State.DEPLOYING_SURVEILLANCE: surveilState,
		State.TARGET_LOST: lostState,
	}
	
	for state in State:
		stateTable[state].switch_state.connect(change_state)

func update_current_state(delta: float) -> void:
	current_state.update_state(delta)
