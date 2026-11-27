extends NPCAbility
class_name AbilityOjiSan

@export var stun_time: float = 6.0

var _timer:float = 0.0
var _player:PlayerActor
var state:Callable

func _on_activate(_world: World) -> void:
	_timer = stun_time
	_player = _world.player
	if _owner_npc.global_position.distance_squared_to(_player.global_position) <= _owner_npc.detection_component.detect_radius:
		state = follow
	else:
		state = search

func _on_use() -> void:
	_target._on_immobilized(true)

func _on_update(delta: float) -> void:
	if _is_using:
		_timer -= delta
		if _timer <= 0.0:
			_target._on_immobilized(false)
			deactivate()
	else:
		state.call(delta)

func _on_deactivate() -> void:
	_is_using = false

func follow(delta:float):
	var minDist:float = _owner_npc.detection_component.detect_radius
	if _owner_npc.global_position.distance_squared_to(_player.global_position) >= _owner_npc.detection_component.detect_radius:
		if !is_instance_valid(_player):
			return
		state = search
		return
	
	if _owner_npc.movement_component.is_target_reached(minDist/2):
		_on_target_reached()
	else:
		_owner_npc.movement_component.move_to(_player.global_position, delta)

func search(delta:float):
	if not is_instance_valid(_player):
		_owner_npc.movement_component.stop_movement()
		return
	
	_owner_npc.movement_component.move_to(_player.global_position, delta)
	var minDist:float = _owner_npc.detection_component.detect_radius
	if _owner_npc.movement_component.is_target_reached(minDist):
		_on_target_reached()

func _on_target_reached() -> void:
	_owner_npc.movement_component.stop_movement()
	state = follow
#
#func _select_next_target() -> void:
	#if _houses.is_empty():
		#_has_search_target = false
		#return
	#
	#var closest_index := 0
	#var closest_distance := _owner_npc.global_position.distance_squared_to(_houses[0])
	#for index in range(1, _houses.size()):
		#var distance := _owner_npc.global_position.distance_squared_to(_houses[index])
		#if distance < closest_distance:
			#closest_index = index
			#closest_distance = distance
	#
	#_next_house = _houses.pop_at(closest_index)
	#_has_search_target = true
