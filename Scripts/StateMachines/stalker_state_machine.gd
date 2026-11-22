extends StateMachine
class_name StalkerStateMachine

enum State {
	SEARCHING,
	PURSUING,
	SURVEILING,
	CAPTURING,
}

@export var searchingState: SearchingState
@export var pursuitState: PursuitState
@export var surveilState: SurveilState
@export var captureState: CaptureState

var current_state_id: State = State.SURVEILING
var stateTable: Dictionary = {}


func _ready() -> void:
	current_state = surveilState
	stateTable = {
		State.SEARCHING: searchingState,
		State.PURSUING: pursuitState,
		State.SURVEILING: surveilState,
		State.CAPTURING: captureState,
	}

	on_state_change.connect(ChangeStateID)


func update_current_state(delta: float) -> void:
	if current_state:
		current_state.update_state(delta)


func ChangeStateID(id: State) -> void:
	if id == State.PURSUING:
		var player := get_tree().get_first_node_in_group("player") as Node2D
		if player != null and pursuitState != null:
			pursuitState.target = player.global_position

	current_state_id = id