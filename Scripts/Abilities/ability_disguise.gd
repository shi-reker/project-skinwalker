extends NPCAbility
class_name AbilityDisguise

@export var disguise_duration: float = 8.0
@export var disguise_alpha: float = 0.4

var _timer: float = 0.0
var _player: PlayerActor = null
var _houses: Array[Vector2] = []
var _next_house: Vector2
var _has_search_target:bool = false
var _original_modulate: Color

func _on_activate(_world: World) -> void:
	_player = _world.player
	for house in EnvironmentManager.house_nodes:
		if not is_instance_valid(house):
			continue
		_houses.append(house.global_position)

func _on_use() -> void:
	pass

func _on_update(delta: float) -> void:
	if _is_using:
		_timer -= delta
		if _timer <= 0.0:
			_target._on_immobilized(false)
			deactivate()
	else:
		if !_has_search_target:
			_owner_npc.movement_component.stop_movement()
			return
		
		_owner_npc.movement_component.move_to(_next_house, delta)
		if _has_search_target and _owner_npc.movement_component.is_target_reached():
			_on_target_reached()

func _on_deactivate() -> void:
	_is_using = false

func _on_target_reached() -> void:
	_select_next_target()
	if not _has_search_target:
		_owner_npc.movement_component.stop_movement()

func _select_next_target() -> void:
	if _houses.is_empty():
		_has_search_target = false
		return
	
	var closest_index := 0
	var closest_distance := _owner_npc.global_position.distance_squared_to(_houses[0])
	for index in range(1, _houses.size()):
		var distance := _owner_npc.global_position.distance_squared_to(_houses[index])
		if distance < closest_distance:
			closest_index = index
			closest_distance = distance
	
	_next_house = _houses.pop_at(closest_index)
	_has_search_target = true
