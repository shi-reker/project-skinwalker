extends ActorState
class_name PursuitState

const CATCH_DISTANCE: float = 50

var target: PlayerActor
var stalker: StalkerActor
var last_known_position: Vector2
var has_last_known_position: bool = false
var _debug_elapsed: float = 1.0
var has_target: bool:
	get:
		return is_instance_valid(target)

func enter(previous_state: StringName) -> void:
	pass

func exit(next_state: StringName) -> void:
	pass

func update_state(delta: float) -> void:
	stalker_manager.debug_label.text = str(self.name)
	stalker_manager.debug_label.text = "\n"+str(stalker.global_position.distance_to(last_known_position))
	_debug_elapsed += delta
	if _debug_elapsed >= 1.0: # for debugging
		if has_target:
			print_debug(
				"[PursuitState] following visible player; stalker=", stalker.global_position,
				" player=", target.global_position,
				" distance=", stalker.global_position.distance_to(target.global_position)
			)
		elif has_last_known_position:
			print_debug(
				"[PursuitState] following last-known position; stalker=", stalker.global_position,
				" goal=", last_known_position,
				" distance=", stalker.global_position.distance_to(last_known_position)
			)
		else:
			print_debug("[PursuitState] no player target or last-known position.")
		_debug_elapsed = 0.0

	if has_target:
		last_known_position = target.global_position
		has_last_known_position = true
		if stalker.global_position.distance_to(last_known_position) <= CATCH_DISTANCE:
			stalker.movement_component.stop_movement()
			stalker_manager.change_state(stalker_manager.captureState)
			return
	elif not has_last_known_position:
		stalker.movement_component.stop_movement()
		return

	stalker.movement_component.move_to(last_known_position, delta)
	if not has_target and stalker.movement_component.is_target_reached(CATCH_DISTANCE):
		stalker.movement_component.stop_movement()
		stalker_manager.change_state(stalker_manager.searchingState)

func set_target(player: PlayerActor) -> void:
	target = player
	last_known_position = player.global_position
	has_last_known_position = true

func lose_target() -> void:
	if has_target:
		last_known_position = target.global_position
		has_last_known_position = true
	target = null
