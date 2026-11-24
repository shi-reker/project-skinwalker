extends NPCAbility
class_name AbilityInnocentIdiot

@export var taunt_radius: float = 400.0
@export var taunt_duration: float = 6.0
@export var taunt_dialogue: DialogueDefinition

var _timer: float = 0.0
var _taunted_stalkers: Array[StalkerActor] = []


#func _on_activate(_context: Dictionary) -> void:
	#_timer = taunt_duration
	#var npc := get_owner_npc()
	#if npc == null:
		#deactivate()
		#return
#
	## Tampilkan dialog taunt (jika ada)
	#if taunt_dialogue != null:
		#var dc := npc.get_node_or_null("Components/DialogueComponent") as DialogueComponent
		#if dc:
			#dc.start_dialogue(taunt_dialogue)
#
	## Paksa Stalker di sekitar mengejar NPC ini
	#var stalkers := get_tree().get_nodes_in_group("stalker")
	#for s in stalkers:
		#if s is StalkerActor and s.global_position.distance_to(npc.global_position) <= taunt_radius:
			#_taunted_stalkers.append(s)
			#if s.state_machine:
				#var pursuit = s.state_machine.stateTable.get(s.state_machine.State.PURSUING)
				#if pursuit:
					#s.target = npc
					#s.state_machine.change_state(pursuit)
			#print("[AbilityInnocentIdiot] Stalker dialihkan ke NPC: ", s.name)
#
	#print("[AbilityInnocentIdiot] NPC jadi umpan selama ", taunt_duration, "s")
#
#
#func _on_update(delta: float) -> void:
	#_timer -= delta
	#if _timer <= 0.0:
		#deactivate()
#
#
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
