
extends ActorState
class_name SurveilState

@export_group("Stalking")
@export var preferred_distance: float = 250.0
@export var minimum_distance: float = 180.0
@export var destination_update_threshold: float = 32.0

@export_group("Aggression")
@export var aggression_distance: float = 300.0
@export var aggression_duration: float = 6.0

@export_group("Lost Target")
@export var lost_sight_grace_period: float = 0.75

@export_group("Visibility")
@export_flags_2d_physics var vision_collision_mask: int = 1

var stalker: StalkerActor

var _aggression_timer: float = 0.0
var _lost_sight_timer: float = 0.0

var _last_stalk_destination: Vector2 = Vector2.ZERO
var _has_stalk_destination: bool = false


func enter(previous_state: StringName) -> void:
	_aggression_timer = 0.0
	_lost_sight_timer = 0.0
	_has_stalk_destination = false

	if stalker == null:
		return

	if stalker.movement_component != null:
		stalker.movement_component.clear_target()

	print("[SurveilState] Entered")


func exit(next_state: StringName) -> void:
	if stalker == null:
		return

	if stalker.movement_component != null:
		stalker.movement_component.stop_movement()
		stalker.movement_component.clear_target()

	_has_stalk_destination = false


func update_state(delta: float) -> void:
	if stalker == null:
		return

	var movement := stalker.movement_component

	if movement == null or movement.movement_definition == null:
		return

	if not is_instance_valid(stalker.target):
		_handle_lost_player(delta)
		return

	if not stalker.is_player_detected:
		_handle_lost_player(delta)
		return

	var player := stalker.target
	_lost_sight_timer = 0.0

	# Player melihat stalker: langsung mengejar.
	if _is_visible_to_player(player):
		_begin_pursuit()
		return

	var distance := stalker.global_position.distance_to(
		player.global_position
	)

	_update_aggression_timer(distance, delta)

	if _aggression_timer >= aggression_duration:
		_begin_pursuit()
		return

	_update_stalking_movement(player, distance, delta)


# --------------------------------------------------
# PLAYER LINE OF SIGHT
# --------------------------------------------------

func _is_visible_to_player(player: PlayerActor) -> bool:
	var space_state := stalker.get_world_2d().direct_space_state

	var query := PhysicsRayQueryParameters2D.create(
		player.global_position,
		stalker.global_position
	)

	query.exclude = [
		player.get_rid(),
		stalker.get_rid()
	]

	query.collision_mask = vision_collision_mask
	query.collide_with_areas = false
	query.collide_with_bodies = true

	var result := space_state.intersect_ray(query)

	# Tidak ada penghalang berarti stalker terlihat.
	return result.is_empty()


# --------------------------------------------------
# STALKING MOVEMENT
# --------------------------------------------------

func _update_stalking_movement(
	player: PlayerActor,
	distance: float,
	delta: float
) -> void:
	var movement := stalker.movement_component
	var speed := movement.movement_definition.walk_speed

	var direction_to_player := (
		stalker.global_position.direction_to(player.global_position)
	)

	var desired_position: Vector2

	if distance < preferred_distance:
		# Terlalu dekat: menjauh dari player.
		desired_position = (
			player.global_position
			- direction_to_player * preferred_distance
		)
	else:
		# Jaga jarak dan bergerak mengikuti player.
		desired_position = (
			player.global_position
			- direction_to_player * preferred_distance
		)

	# Perbarui target hanya jika player/stalker sudah berpindah cukup jauh.
	if (
		not _has_stalk_destination
		or _last_stalk_destination.distance_to(desired_position)
		> destination_update_threshold
	):
		_last_stalk_destination = desired_position
		_has_stalk_destination = true

	movement.move_to(
		_last_stalk_destination,
		delta,
		speed
	)


# --------------------------------------------------
# AGGRESSION
# --------------------------------------------------

func _update_aggression_timer(distance: float, delta: float) -> void:
	if distance <= aggression_distance:
		_aggression_timer += delta
	else:
		_aggression_timer = 0.0


func _begin_pursuit() -> void:
	if stalker == null:
		return

	print("[SurveilState] Player spotted! Starting pursuit.")

	stalker.state_machine.change_state(
		stalker.state_machine.pursuitState
	)


# --------------------------------------------------
# LOST PLAYER
# --------------------------------------------------

func _handle_lost_player(delta: float) -> void:
	_lost_sight_timer += delta

	if _lost_sight_timer < lost_sight_grace_period:
		return

	print("[SurveilState] Player lost. Returning to search.")

	stalker.state_machine.change_state(
		stalker.state_machine.searchingState
	)
