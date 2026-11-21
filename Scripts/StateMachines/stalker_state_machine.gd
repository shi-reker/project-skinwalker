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
	if initial_state == null:
		initial_state = surveilState
	current_state = initial_state
	stateTable = {
		State.SEARCHING: searchingState,
		State.PURSUING: pursuitState,
		State.SURVEILING: surveilState,
		State.CAPTURING: captureState,
	}
	on_state_change.connect(_change_state_id)

func update_current_state(delta: float) -> void:
	print_debug(current_state.state_name)
	current_state.update_state(delta)
	
	#if target == null or not is_instance_valid(target):
		#return
	#distToTarget = global_position.distance_to(target.global_position)
	#if distToTarget < 60 and state_machine.current_state != state_machine.captureState:
		#state_machine.change_state(state_machine.captureState)

func _change_state_id(id: State) -> void:
	current_state_id = id

func _on_detected(seen: Array[CharacterBody2D]) -> void:
	for body in seen:
		var player := body as PlayerActor
		if player == null:
			continue
		#print_debug("SEE YOU")
		pursuitState.target = player
		var stalker := actor as StalkerActor
		if stalker != null:
			stalker.target = player
		if current_state != pursuitState and current_state != captureState:
			change_state(pursuitState)
			print_debug("PURSUING")
		return
