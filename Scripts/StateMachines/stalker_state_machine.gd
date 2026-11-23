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

var stalker: StalkerActor

func setup(actor_node: CharacterBody2D) -> void:
	current_state_id = State.SURVEILING
	if initial_state == null:
		initial_state = surveilState
	current_state = initial_state
	stateTable = {
		State.SEARCHING: searchingState,
		State.PURSUING: pursuitState,
		State.SURVEILING: surveilState,
		State.CAPTURING: captureState,
	}
	super.setup(actor_node)
	stalker = actor_node as StalkerActor
	searchingState.stalker = stalker
	pursuitState.stalker = stalker
	surveilState.stalker = stalker
	captureState.stalker = stalker
	print_debug(
		"[StalkerStateMachine] setup actor=", actor_node.name,
		" initial_state=", current_state.state_name
	)
	# setup(actor)
	# on_state_change.connect(_change_state_id)

#func _change_state_id(id: State) -> void:
#func change_state(next_state: ActorState):
	#super.change_state(next_state)
	#current_state_id = id

func handle_dist_to_player(dist:float):
	if dist < 160:
		change_state(surveilState)
	elif dist < 64:
		change_state(captureState)

# func _on_detected(seen: Array[CharacterBody2D]) -> void:
# 	for body in seen:
# 		var player := body as PlayerActor
# 		if player == null:
# 			continue
# 		#print_debug("SEE YOU")
# 		pursuitState.target = player
# 		var stalker := actor as StalkerActor
# 		if stalker != null:
# 			stalker.target = player
# 		if current_state != pursuitState and current_state != captureState:
# 			change_state(pursuitState)
# 			print_debug("PURSUING")
func change_state(next_state: ActorState) -> void:
	if next_state == current_state:
		return

	var previous_state := current_state
	if previous_state == pursuitState and next_state == searchingState:
		print_debug(
			"[StalkerStateMachine] Last-known position reached without reacquiring player; starting search."
		)
	elif next_state == captureState:
		print_debug("[StalkerStateMachine] Catch range reached; entering capture state.")

	super.change_state(next_state)
	current_state_id = current_state.state_code
	print_debug(
		"[StalkerStateMachine] state changed: ", previous_state.state_name,
		" -> ", current_state.state_name,
		" (code=", current_state_id, ")"
	)

func _on_detected(player: PlayerActor) -> void:
	if is_instance_valid(player):
		_player_found(player)
	else:
		_player_not_found()

func _player_found(player: PlayerActor) -> void:
	pursuitState.set_target(player)
	if stalker != null:
		stalker.target = player
		stalker.is_player_detected = true
	print_debug(
		"[StalkerStateMachine] player detected: ", player.name,
		" at ", player.global_position
	)
	if current_state != pursuitState and current_state != captureState:
		change_state(pursuitState)

func _player_not_found() -> void:
	if pursuitState.has_target:
		pursuitState.lose_target()
		print_debug(
			"[StalkerStateMachine] player lost; pursuing last-known position ",
			pursuitState.last_known_position
		)
	elif pursuitState.has_last_known_position:
		print_debug(
			"[StalkerStateMachine] player still not visible; continuing to ",
			pursuitState.last_known_position
		)
	else:
		print_debug("[StalkerStateMachine] no visible player or last-known position.")
	if stalker != null:
		stalker.target = null
		stalker.is_player_detected = false
