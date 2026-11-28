
extends ActorState
class_name PursuitState


# =========================================================
# Configuration
# =========================================================

const CATCH_DISTANCE: float = 50.0

var stalker: StalkerActor

var _debug_elapsed: float = 0.0


# =========================================================
# Target Information
# =========================================================

var has_target: bool:
	get:
		return (
			stalker != null
			and stalker.is_player_detected
			and is_instance_valid(stalker.target)
		)

var has_last_known_position: bool:
	get:
		return stalker != null and stalker.has_last_known_position


# =========================================================
# State Lifecycle
# =========================================================

func enter(previous_state: StringName) -> void:
	_debug_elapsed = 0.0

	if stalker == null:
		return

	stalker.movement_component.clear_target()

	print_debug("[PursuitState] Entered pursuit.")


func exit(next_state: StringName) -> void:
	if stalker == null:
		return

	stalker.movement_component.stop_movement()
	stalker.movement_component.clear_target()


# =========================================================
# State Update
# =========================================================

func update_state(delta: float) -> void:
	if stalker == null or stalker.movement_component == null:
		return

	_update_debug(delta)

	# Case 1: Player is currently visible.
	if has_target:
		_pursue_visible_player(delta)
		return

	# Case 2: Player is no longer visible.
	if has_last_known_position:
		_pursue_last_known_position(delta)
		return

	# Case 3: No target information available.
	stalker.movement_component.stop_movement()
	stalker_manager.change_state(stalker_manager.searchingState)


# =========================================================
# Visible Player Pursuit
# =========================================================

func _pursue_visible_player(delta: float) -> void:
	var player := stalker.target

	# Update the shared last-known position.
	stalker.last_known_position = player.global_position
	stalker.has_last_known_position = true

	var distance := stalker.global_position.distance_to(
		player.global_position
	)

	# Capture the player when close enough.
	if distance <= CATCH_DISTANCE:
		stalker.movement_component.stop_movement()
		stalker_manager.change_state(stalker_manager.captureState)
		return

	# Chase using running speed.
	stalker.movement_component.move_to(
		player.global_position,
		delta,
		stalker.movement_component.movement_definition.run_speed
	)


# =========================================================
# Last Known Position Pursuit
# =========================================================

func _pursue_last_known_position(delta: float) -> void:
	var movement := stalker.movement_component
	var run_speed := movement.movement_definition.run_speed

	movement.move_to(
		stalker.last_known_position,
		delta,
		run_speed
	)

	# If the stalker reaches the last-known position,
	# it should begin searching.
	if movement.is_target_reached(CATCH_DISTANCE):
		movement.stop_movement()
		stalker_manager.change_state(stalker_manager.searchingState)


# =========================================================
# Target Management
# =========================================================

func set_target(player: PlayerActor) -> void:
	if stalker == null or not is_instance_valid(player):
		return

	stalker.target = player
	stalker.last_known_position = player.global_position
	stalker.has_last_known_position = true
	stalker.is_player_detected = true


func lose_target() -> void:
	if stalker == null:
		return

	if is_instance_valid(stalker.target):
		stalker.last_known_position = stalker.target.global_position
		stalker.has_last_known_position = true

	stalker.target = null
	stalker.is_player_detected = false


# =========================================================
# Debugging
# =========================================================

func _update_debug(delta: float) -> void:
	_debug_elapsed += delta

	if _debug_elapsed < 1.0:
		return

	_debug_elapsed = 0.0

	if stalker_manager.debug_label != null:
		stalker_manager.debug_label.text = (
			"Pursuit\nDistance: %.1f" %
			stalker.global_position.distance_to(
				stalker.last_known_position
			)
		)

	if has_target:
		print_debug(
			"[PursuitState] Following visible player; distance=",
			stalker.global_position.distance_to(stalker.target.global_position)
		)
	elif has_last_known_position:
		print_debug(
			"[PursuitState] Following last-known position; distance=",
			stalker.global_position.distance_to(stalker.last_known_position)
		)
