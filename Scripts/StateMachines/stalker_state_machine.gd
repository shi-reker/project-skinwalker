
extends StateMachine
class_name StalkerStateMachine


# =========================================================
# State Definitions
# =========================================================

enum State {
	SEARCHING,
	PURSUING,
	SURVEILLING,
	CAPTURING,
}


# =========================================================
# State References
# =========================================================

@export_group("States")

@export var searchingState: SearchingState
@export var pursuitState: PursuitState
@export var surveilState: SurveilState
@export var captureState: CaptureState

@export_group("Debug")

@export var debug_label: Label


# =========================================================
# Actor Reference
# =========================================================

var stalker: StalkerActor


# =========================================================
# Initialization
# =========================================================

func setup(actor_node: CharacterBody2D) -> void:
	stalker = actor_node as StalkerActor

	if stalker == null:
		push_error("StalkerStateMachine: Actor must be a StalkerActor.")
		return

	# SurveilState is currently unused.
	if initial_state == null:
		initial_state = searchingState

	stateTable = {
		State.SEARCHING: searchingState,
		State.PURSUING: pursuitState,
		State.SURVEILLING: surveilState,
		State.CAPTURING: captureState,
	}

	super.setup(actor_node)

	_initialize_states()

	print_debug(
		"[StalkerStateMachine] Initialized: ",
		stalker.name,
		" | Initial state: ",
		current_state.state_name
	)


func _initialize_states() -> void:
	for state: ActorState in stateTable.values():
		if state == null:
			continue

		state.stalker_manager = self
		state.stalker = stalker


# =========================================================
# State Updates
# =========================================================

func update_current_state(delta: float) -> void:
	super.update_current_state(delta)


# =========================================================
# State Transitions
# =========================================================

func change_state(next_state: ActorState) -> void:
	if next_state == null:
		push_warning("StalkerStateMachine: Cannot change to a null state.")
		return

	if next_state == current_state:
		return

	var previous_state := current_state

	super.change_state(next_state)

	if current_state == null:
		return

	current_state_id = current_state.state_code

	_log_state_change(previous_state, current_state)


func _log_state_change(
	previous_state: ActorState,
	next_state: ActorState
) -> void:
	if previous_state == pursuitState and next_state == searchingState:
		print_debug(
			"[StalkerStateMachine] Last-known position reached. Starting search."
		)

	elif next_state == captureState:
		print_debug(
			"[StalkerStateMachine] Capture range reached."
		)

	print_debug(
		"[StalkerStateMachine] State changed: ",
		previous_state.state_name if previous_state != null else "None",
		" -> ",
		next_state.state_name,
		" | Code: ",
		current_state_id
	)


# =========================================================
# Detection Handling
# =========================================================

func _on_detected(player: PlayerActor) -> void:
	if is_instance_valid(player):
		_player_found(player)
	else:
		_player_not_found()


func _player_found(player: PlayerActor) -> void:
	stalker.target = player
	stalker.last_known_position = player.global_position
	stalker.has_last_known_position = true
	stalker.is_player_detected = true

	pursuitState.set_target(player)

	print_debug(
		"[StalkerStateMachine] Player detected: ",
		player.name
	)

	if current_state == captureState:
		return

	if current_state == pursuitState:
		return

	if current_state != surveilState:
		change_state(surveilState)

func _player_not_found() -> void:
	if stalker == null:
		return

	# Preserve the last-known position before clearing the target.
	if is_instance_valid(stalker.target):
		stalker.last_known_position = stalker.target.global_position
		stalker.has_last_known_position = true

	# Keep PursuitState synchronized.
	if pursuitState.has_target:
		pursuitState.lose_target()

	stalker.target = null
	stalker.is_player_detected = false

	if stalker.has_last_known_position:
		print_debug(
			"[StalkerStateMachine] Player lost. Last known position: ",
			stalker.last_known_position
		)
	else:
		print_debug(
			"[StalkerStateMachine] Player lost. No last-known position available."
		)
