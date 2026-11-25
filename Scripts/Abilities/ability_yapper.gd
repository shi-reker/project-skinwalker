extends NPCAbility
class_name AbilityYapper

@export var distraction_radius: float = 300.0
@export var distraction_duration: float = 5.0
@export var hint_bonus_confidence: float = 0.3

var _distraction_timer: float = 0.0
var _distraction_position: Vector2

func _on_activate(_world: World) -> void:
	_distraction_timer = distraction_duration

	var npc := get_owner_npc()
	if npc == null:
		return

	_distraction_position = npc.global_position

	#_notify_nearby_stalkers()
	#_give_player_hint_bonus()

	print("[AbilityYapper] Distraksi aktif di ", _distraction_position)


func _on_update(delta: float) -> void:
	if _is_using:
		_target.velocity = Vector2.ZERO
		_distraction_timer -= delta
		if _distraction_timer <= 0.0:
			deactivate()

func _on_deactivate() -> void:
	_is_using = false
	_is_active = false
	print("[AbilityYapper] Distraksi selesai")

#func _notify_nearby_stalkers() -> void:
	#var npc := get_owner_npc()
	#if npc == null:
		#return
	#var tree := npc.get_tree()
	#if tree == null:
		#return
#
	#var stalkers := tree.get_nodes_in_group("stalker")
	#for s in stalkers:
		#if s is StalkerActor and s.global_position.distance_to(_distraction_position) <= distraction_radius:
			#if s.state_machine:
				#var search_state = s.state_machine.stateTable.get(s.state_machine.State.SEARCHING)
				#if search_state:
					#s.state_machine.change_state(search_state)
					#s.target = null
			#print("[AbilityYapper] Stalker dialihkan: ", s.name)
#
#
#func _give_player_hint_bonus() -> void:
	#var npc := get_owner_npc()
	#if npc == null:
		#return
	#var tree := npc.get_tree()
	#if tree == null:
		#return
#
	#var player := tree.get_first_node_in_group("player") as PlayerActor
	#if player == null:
		#return
#
	#for h in player.player_hints:
		#if h != null:
			#h.confidence = min(1.0, h.confidence + hint_bonus_confidence)
