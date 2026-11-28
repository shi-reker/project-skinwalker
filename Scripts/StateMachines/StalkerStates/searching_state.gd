
extends ActorState
class_name SearchingState


# =========================================================
# References
# =========================================================

@export var noise: AudioStreamPlayer2D

var stalker: StalkerActor


# =========================================================
# Search Data
# =========================================================

var target_positions: Array[Vector2] = []
var target: Vector2 = Vector2.ZERO

var has_search_target: bool = false
var investigating_last_known_position: bool = false


# =========================================================
# State Lifecycle
# =========================================================

func enter(previous_state: StringName) -> void:
	if stalker == null:
		return

	if noise != null:
		noise.play()

	# Investigate the player's last-known position first.
	if stalker.has_last_known_position:
		target = stalker.last_known_position
		has_search_target = true
		investigating_last_known_position = true

		print_debug(
			"[SearchingState] Investigating last-known position: ",
			target
		)
	else:
		investigating_last_known_position = false
		setup_candidates_pos()


func exit(next_state: StringName) -> void:
	if noise != null:
		noise.stop()

	if stalker != null and stalker.movement_component != null:
		stalker.movement_component.stop_movement()
		stalker.movement_component.clear_target()


# =========================================================
# State Update
# =========================================================

func update_state(delta: float) -> void:
	if stalker == null or stalker.movement_component == null:
		return

	if stalker_manager.debug_label != null:
		stalker_manager.debug_label.text = str(self.name)

	if not has_search_target:
		stalker.movement_component.stop_movement()
		return

	# Search using running speed.
	var run_speed := stalker.movement_component.movement_definition.run_speed

	stalker.movement_component.move_to(
		target,
		delta,
		run_speed
	)

	if is_target_reached():
		_on_target_reached()


# =========================================================
# Target Checking
# =========================================================

func is_target_reached() -> bool:
	return (
		has_search_target
		and stalker.movement_component.is_target_reached()
	)


# =========================================================
# Search Setup
# =========================================================

func setup_candidates_pos() -> void:
	target_positions = EnvironmentManager.get_candidates_pos(
		stalker.hints
	)

	_select_next_target()


# =========================================================
# Search Progression
# =========================================================

func _on_target_reached() -> void:
	stalker.movement_component.stop_movement()
	stalker.movement_component.clear_target()

	# The stalker has investigated the last-known position.
	if investigating_last_known_position:
		investigating_last_known_position = false
		stalker.has_last_known_position = false

		print_debug(
			"[SearchingState] Last-known position investigated."
		)

		# Continue searching the surrounding environment.
		setup_candidates_pos()
		return

	# Continue to the next candidate position.
	_select_next_target()

	if not has_search_target:
		stalker.movement_component.stop_movement()
		print_debug("[SearchingState] No more search positions.")


# =========================================================
# Candidate Selection
# =========================================================

func _select_next_target() -> void:
	if target_positions.is_empty():
		has_search_target = false
		return

	var closest_index := 0

	var closest_distance := stalker.global_position.distance_squared_to(
		target_positions[0]
	)

	for index in range(1, target_positions.size()):
		var distance := stalker.global_position.distance_squared_to(
			target_positions[index]
		)

		if distance < closest_distance:
			closest_index = index
			closest_distance = distance

	target = target_positions.pop_at(closest_index)
	has_search_target = true

	print_debug(
		"[SearchingState] New search destination: ",
		target
	)
