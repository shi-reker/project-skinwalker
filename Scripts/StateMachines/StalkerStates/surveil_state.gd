
extends ActorState
class_name SurveilState


# =========================================================
# Surveillance Settings
# =========================================================

@export_group("Stalking")

@export var preferred_distance: float = 120.0
@export var distance_tolerance: float = 30.0

@export_group("Aggression")

@export var aggression_distance: float = 180.0
@export var aggression_duration: float = 6.0

@export_group("Lost Target")

@export var lost_sight_grace_period: float = 0.75


# =========================================================
# Runtime Data
# =========================================================

var stalker: StalkerActor

var _aggression_timer: float = 0.0
var _lost_sight_timer: float = 0.0

var _last_stalk_destination: Vector2 = Vector2.ZERO
var _has_stalk_destination: bool = false


# =========================================================
# State Lifecycle
# =========================================================

func enter(previous_state: StringName) -> void:
	_aggression_timer = 0.0
	_lost_sight_timer = 0.0

	_has_stalk_destination = false

	print_debug("[SurveilState] Stalker began surveilling.")


func exit(next_state: StringName) -> void:
	if stalker != null:
		stalker.movement_component.stop_movement()
		stalker.movement_component.clear_target()


# =========================================================
# State Update
# =========================================================

func update_state(delta: float) -> void:
	if stalker == null:
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
	var speed := movement.movement_definition.walk_speed

	# Direction from the player toward the stalker.
	var away_direction := player.global_position.direction_to(
		stalker.global_position
	)

	if away_direction == Vector2.ZERO:
		away_direction = Vector2.RIGHT

	# The desired position is behind the player, maintaining distance.
	var desired_position := (
		player.global_position
		+ away_direction * preferred_distance
	)

	var minimum_distance := preferred_distance - distance_tolerance
	var maximum_distance := preferred_distance + distance_tolerance

	# Already maintaining a comfortable distance.
	if distance >= minimum_distance and distance <= maximum_distance:
		movement.stop_movement()
		_has_stalk_destination = false
		return

	# Update the destination when the player has moved significantly.
	if (
		not _has_stalk_destination
		or _last_stalk_destination.distance_to(desired_position) > 12.0
	):
		_last_stalk_destination = desired_position
		_has_stalk_destination = true
	print(
	"[SurveilState] Moving toward: ",
	_last_stalk_destination,
	" | Speed: ",
	speed
)
	movement.move_to(
		_last_stalk_destination,
		delta,
		speed
	)
	print(
	"[SurveilState] Player distance: ", distance,
	" | Preferred distance: ", preferred_distance,
	" | Target: ", desired_position
)


# =========================================================
# Aggression
# =========================================================

func _update_aggression_timer(distance: float, delta: float) -> void:
	if distance <= aggression_distance:
		_aggression_timer += delta
	else:
		_aggression_timer = 0.0


func _begin_pursuit() -> void:
	print_debug(
		"[SurveilState] Player stayed nearby too long. "
		+ "Escalating to pursuit."
	)

	stalker_manager.change_state(stalker_manager.pursuitState)


# =========================================================
# Lost Player
# =========================================================

func _handle_lost_player(delta: float) -> void:
	_lost_sight_timer += delta

	if _lost_sight_timer < lost_sight_grace_period:
		# Keep the stalker stationary briefly before investigating.
		stalker.movement_component.stop_movement()
		return

	print_debug(
		"[SurveilState] Player lost. Moving to search state."
	)

	stalker_manager.change_state(stalker_manager.searchingState)
