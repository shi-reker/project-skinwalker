extends NPCAbility
class_name AbilityInnocentIdiot

@export var fight_duration:float = 6.0

var _timer:float = 0.0

func _on_activate(world: World) -> void:
	_timer = fight_duration
	
	_target = world.stalker

func _on_use() -> void:
	_owner_npc.movement_component.stop_movement()

func _on_update(delta: float) -> void:
	if _is_using:
		_timer -= delta
		if _timer <= 0.0:
			deactivate()
	else:
		_owner_npc.movement_component.move_to(_target.global_position, delta)

#func _on_deactivate() -> void:
	## Kembalikan fokus Stalker ke player (jika player terdeteksi)
	#for s in _taunted_stalkers:
		#if is_instance_valid(s) and s.target == get_owner_npc():
			#var player := get_tree().get_first_node_in_group("player") as PlayerActor
			#if player != null:
				#s.target = player
	#_taunted_stalkers.clear()
	#_start_cooldown()
	#print("[AbilityInnocentIdiot] Umpan selesai")
