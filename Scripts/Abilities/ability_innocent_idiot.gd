extends NPCAbility
class_name AbilityInnocentIdiot

@export var fight_duration:float = 6.0

var _timer:float = 0.0

func _on_activate(world: World) -> void:
	_timer = fight_duration
	
	_target = world.stalker

func _on_use() -> void:
	_owner_npc.movement_component.stop_movement()
	_target._on_immobilized(true)

func _on_update(delta: float) -> void:
	if _is_using:
		_timer -= delta
		if _timer <= 0.0:
			_target._on_immobilized(false)
			deactivate()
	else:
		_owner_npc.movement_component.move_to(_target.global_position, delta)

func _on_deactivate() -> void:
	_is_using = false
	print("[AbilityYapper] Distraksi selesai")
