extends StateMachine
class_name StalkerStateMachine

enum State {
	SEARCHING,
	PURSUING,
	SURVEILING,
	CAPTURING,
}

@export var searchingState:SearchingState
@export var pursuitState:PursuitState
@export var surveilState:SurveilState
@export var captureState:CaptureState

var current_state_id: State = State.SURVEILING

var stateTable:Dictionary[State, ActorState]

func _ready() -> void:
	#initial_state = State.SEARCHING
	current_state = surveilState
	stateTable = {
		State.SEARCHING: searchingState,
		State.PURSUING: pursuitState,
		State.SURVEILING: surveilState,
		State.CAPTURING: captureState,
	}
	setup(actor)
	on_state_change.connect(ChangeStateID)

func update_current_state(delta: float) -> void:
	#print_debug(current_state.state_name)
	current_state.update_state(delta)

func ChangeStateID(id:State):
	if id == State.PURSUING:
		pursuitState.target = get_parent().global_position
	
	current_state_id = id
	print_debug(current_state.state_name)
