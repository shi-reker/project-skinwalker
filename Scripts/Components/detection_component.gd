
extends Area2D
class_name DetectionComponent


# =========================================================
# Detection Settings
# =========================================================

@export_group("Detection")
@export var detect_shape: CollisionShape2D

@export_range(1, 2000, 1) var detect_radius: int = 200:
	set(value):
		if value <= 0:
			return

		detect_radius = value
		_update_detect_shape()


# =========================================================
# Detection Data
# =========================================================

var actor: CharacterBody2D = null

# Other CharacterBody2D targets, excluding the player.
var detected_nodes: Array[CharacterBody2D] = []

# The player's existing DetectArea nodes.
var detected_player_areas: Array[Area2D] = []

var current_visible_player: PlayerActor
var target_conditions: Array[Callable] = []


# =========================================================
# Signals
# =========================================================

signal detected(nodes: Array[CharacterBody2D])
signal player_detected(player: PlayerActor)
signal target_detected(target: Node2D)
signal stalker_detected(stalker: StalkerActor)


# =========================================================
# Initialization
# =========================================================

func _ready() -> void:
	_update_detect_shape()

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)

	if not area_exited.is_connected(_on_area_exited):
		area_exited.connect(_on_area_exited)


func setup(_owner: CharacterBody2D) -> void:
	actor = _owner


# =========================================================
# Physics Update
# =========================================================

func _physics_process(_delta: float) -> void:
	_update_visibility()


# =========================================================
# Detection Shape
# =========================================================

func _update_detect_shape() -> void:
	if detect_shape == null or detect_shape.shape == null:
		return

	var shape := detect_shape.shape

	if shape is CircleShape2D:
		shape.radius = detect_radius


# =========================================================
# Visibility Checking
# =========================================================

func _update_visibility() -> void:
	var space_state := get_world_2d().direct_space_state

	var visible_targets: Array[CharacterBody2D] = []
	var visible_player: PlayerActor = null

	# Detect other CharacterBody2D objects.
	for target in detected_nodes:
		if not is_instance_valid(target):
			continue

		if not _has_line_of_sight(space_state, target):
			continue

		visible_targets.append(target)
		_check_target_conditions(target)

	# Detect the player through their DetectArea.
	for player_area in detected_player_areas:
		if not is_instance_valid(player_area):
			continue

		var player := player_area.get_parent() as PlayerActor

		if player == null:
			continue

		if not _has_line_of_sight_to_player(
			space_state,
			player_area,
			player
		):
			continue

		if not visible_targets.has(player):
			visible_targets.append(player)

		if visible_player == null:
			visible_player = player

		_check_target_conditions(player)

	_update_visible_player(visible_player)

	detected.emit(visible_targets)


# =========================================================
# Line of Sight: Character Bodies
# =========================================================

func _has_line_of_sight(
	space_state: PhysicsDirectSpaceState2D,
	target: CharacterBody2D
) -> bool:
	var query := PhysicsRayQueryParameters2D.create(
		global_position,
		target.global_position
	)

	query.exclude = _get_excluded_rids()

	var result := space_state.intersect_ray(query)

	return (
		not result.is_empty()
		and result.get("collider") == target
	)


# =========================================================
# Line of Sight: Player DetectArea
# =========================================================

func _has_line_of_sight_to_player(
	space_state: PhysicsDirectSpaceState2D,
	player_area: Area2D,
	player: PlayerActor
) -> bool:
	var query := PhysicsRayQueryParameters2D.create(
		global_position,
		player_area.global_position
	)

	query.exclude = _get_excluded_rids()
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var result := space_state.intersect_ray(query)

	if result.is_empty():
		return false

	var collider: Object = result.get("collider")

	return collider == player_area or collider == player


# =========================================================
# Raycast Exclusions
# =========================================================

func _get_excluded_rids() -> Array[RID]:
	var excluded: Array[RID] = [get_rid()]

	if is_instance_valid(actor):
		excluded.append(actor.get_rid())

	return excluded


# =========================================================
# Target Conditions
# =========================================================

func _check_target_conditions(target: CharacterBody2D) -> void:
	for condition: Callable in target_conditions:
		if not condition.is_valid():
			continue

		if condition.call(target):
			target_detected.emit(target)


# =========================================================
# Player Visibility
# =========================================================

func _update_visible_player(player: PlayerActor) -> void:
	if current_visible_player == player:
		return

	current_visible_player = player
	player_detected.emit(player)


# =========================================================
# Body Detection
# =========================================================

func _on_body_entered(body: Node2D) -> void:
	var character_body := body as CharacterBody2D

	if character_body == null:
		return

	# Player detection is handled through DetectArea.
	if character_body is PlayerActor:
		return

	if not detected_nodes.has(character_body):
		detected_nodes.append(character_body)

	if character_body is StalkerActor:
		stalker_detected.emit(character_body as StalkerActor)


func _on_body_exited(body: Node2D) -> void:
	var character_body := body as CharacterBody2D

	if character_body == null:
		return

	detected_nodes.erase(character_body)


# =========================================================
# Area Detection
# =========================================================

func _on_area_entered(area: Area2D) -> void:
	if not area.get_parent() is PlayerActor:
		return

	if not detected_player_areas.has(area):
		detected_player_areas.append(area)


func _on_area_exited(area: Area2D) -> void:
	detected_player_areas.erase(area)
