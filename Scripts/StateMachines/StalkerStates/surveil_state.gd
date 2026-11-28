
extends ActorState
class_name SurveilState


# =========================================================
# Stalking Settings
# =========================================================

@export_group("Stalking")

@export var preferred_distance: float = 120.0
@export var minimum_distance: float = 60.0


# =========================================================
# Aggression Settings
# =========================================================

@export_group("Aggression")

@export var aggression_distance: float = 180.0
@export var aggression_duration: float = 6.0


# =========================================================
# Lost Target Settings
# =========================================================

@export_group("Lost Target")

@export var lost_sight_grace_period: float = 0.75


# =========================================================
# State Data
# =========================================================

var stalker: StalkerActor

var _aggression_timer: float = 0.0
var _lost_sight_timer: float = 0.0

var _last_stalk_destination: Vector2 = Vector2.ZERO
var _has_stalk_destination: bool = false


# =========================================================
# State Initialization
# =========================================================

func enter(previous_state: StringName) -> void:
	_aggression_timer = 0.0
	_lost_sight_timer = 0.0
	_has_stalk_destination = false

	if stalker == null:
		return

	if stalker.movement_component != null:
		stalker.movement_component.clear_target()

	print("[SurveilState] Stalker began surveilling.")


func exit(next_state: StringName) -> void:
	if stalker == null:
		return

	if stalker.movement_component != null:
		stalker.movement_component.stop_movement()
		stalker.movement_component.clear_target()

	_has_stalk_destination = false


# =========================================================
# State Update
# =========================================================

func update_state(delta: float) -> void:
	if stalker == null:
		return

	var movement := stalker.movement_component

	if movement == null:
		return

	if not is_instance_valid(stalker.target) or not stalker.is_player_detected:
		_handle_lost_player(delta)
		return

	_lost_sight_timer = 0.0

	var player := stalker.target

	var distance := stalker.global_position.distance_to(
		player.global_position
	)

	_update_aggression_timer(distance, delta)

	if _aggression_timer >= aggression_duration:
		_begin_pursuit()
		return

	_update_stalking_movement(player, distance, delta)


# =========================================================
# Stalking Movement
# =========================================================

func _update_stalking_movement(
	player: PlayerActor,
	distance: float,
	delta: float
) -> void:
	var movement := stalker.movement_component

	if movement == null or movement.movement_definition == null:
		return

	var speed := movement.movement_definition.walk_speed

	# Do not create a destination that moves the stalker backward.
	if distance <= minimum_distance:
		return

	# Calculate direction from stalker toward player.
	var direction_to_player := stalker.global_position.direction_to(
		player.global_position
	)

	# Destination is between stalker and player.
	# It can never be behind the stalker.
	var desired_position := (
		stalker.global_position
		+ direction_to_player * (distance - minimum_distance)
	)

	# Update destination only when it changes significantly.
	if (
		not _has_stalk_destination
		or _last_stalk_destination.distance_to(desired_position) > 12.0
	):
		_last_stalk_destination = desired_position
		_has_stalk_destination = true

		print(
			"[SurveilState] New destination: ",
			_last_stalk_destination
		)

	if not _has_stalk_destination:
		return

	movement.move_to(
		_last_stalk_destination,
		delta,
		speed
	)


# =========================================================
# Aggression
# =========================================================

func _update_aggression_timer(
	distance: float,
	delta: float
) -> void:
	if distance <= aggression_distance:
		_aggression_timer += delta
	else:
		_aggression_timer = 0.0


# =========================================================
# Pursuit Transition
# =========================================================

func _begin_pursuit() -> void:
	print("[SurveilState] Aggression threshold reached.")
	print("[SurveilState] Switching to PursuitState.")

	stalker_manager.change_state(
		stalker_manager.pursuitState
	)


# =========================================================
# Lost Player Handling
# =========================================================

func _handle_lost_player(delta: float) -> void:
	_lost_sight_timer += delta

	if _lost_sight_timer < lost_sight_grace_period:
		return

	print("[SurveilState] Player lost. Returning to SearchingState.")

	stalker_manager.change_state(
		stalker_manager.searchingState
	)
