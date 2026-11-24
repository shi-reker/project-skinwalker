extends ActorState
class_name SearchingState

@export var noise:AudioStreamPlayer2D
var stalker: StalkerActor

var target_positions: Array[Vector2] = []
var target: Vector2
var has_search_target: bool = false

func enter(previous_state: StringName) -> void:
	if noise != null:
		noise.play()
	setup_candidates_pos()

func update_state(delta: float) -> void:
	stalker_manager.debug_label.text = str(self.name)
	if not has_search_target:
		stalker.movement_component.stop_movement()
		return

	stalker.movement_component.move_to(target, delta)
	if is_target_reached():
		_on_target_reached()

func exit(next_state: StringName) -> void:
	if noise != null:
		noise.stop()

func is_target_reached() -> bool:
	return has_search_target and stalker.movement_component.is_target_reached()

func setup_candidates_pos() -> void:
	target_positions = EnvironmentManager.get_candidates_pos(stalker.hints)
	_select_next_target()

func _on_target_reached() -> void:
	_select_next_target()
	if not has_search_target:
		stalker.movement_component.stop_movement()

func _select_next_target() -> void:
	if target_positions.is_empty():
		has_search_target = false
		return

	var closest_index := 0
	var closest_distance := stalker.global_position.distance_squared_to(target_positions[0])
	for index in range(1, target_positions.size()):
		var distance := stalker.global_position.distance_squared_to(target_positions[index])
		if distance < closest_distance:
			closest_index = index
			closest_distance = distance

	target = target_positions.pop_at(closest_index)
	has_search_target = true
