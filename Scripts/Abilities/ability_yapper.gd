extends NPCAbility
class_name AbilityYapper

@export var distraction_radius: float = 300.0
@export var distraction_duration: float = 5.0
@export var hint_bonus_confidence: float = 0.3

var _distraction_timer: float = 0.0
var _audio_player: AudioStreamPlayer2D = null
var _distraction_position: Vector2


func _on_activate(_context: Dictionary) -> void:
	_distraction_timer = distraction_duration

	var npc := get_owner_npc()
	if npc == null:
		return

	_distraction_position = npc.global_position
	_audio_player = AudioStreamPlayer2D.new()
	_audio_player.stream = load("res://Assets/Audio/pipe.wav")
	_audio_player.global_position = _distraction_position
	_audio_player.max_distance = distraction_radius
	npc.get_parent().add_child(_audio_player)
	_audio_player.play()

	_notify_nearby_stalkers()
	_give_player_hint_bonus()

	print("[AbilityYapper] Distraksi aktif di ", _distraction_position)


func _on_update(delta: float) -> void:
	_distraction_timer -= delta
	if _distraction_timer <= 0.0:
		deactivate()


func _on_deactivate() -> void:
	if _audio_player != null and is_instance_valid(_audio_player):
		_audio_player.stop()
		_audio_player.queue_free()
	_audio_player = null
	_start_cooldown()
	print("[AbilityYapper] Distraksi selesai")


func _notify_nearby_stalkers() -> void:
	var npc := get_owner_npc()
	if npc == null:
		return
	var tree := npc.get_tree()
	if tree == null:
		return

	var stalkers := tree.get_nodes_in_group("stalker")
	for s in stalkers:
		if s is StalkerActor and s.global_position.distance_to(_distraction_position) <= distraction_radius:
			if s.state_machine:
				var search_state = s.state_machine.stateTable.get(s.state_machine.State.SEARCHING)
				if search_state:
					s.state_machine.change_state(search_state)
					s.target = null
			print("[AbilityYapper] Stalker dialihkan: ", s.name)


func _give_player_hint_bonus() -> void:
	var npc := get_owner_npc()
	if npc == null:
		return
	var tree := npc.get_tree()
	if tree == null:
		return

	var player := tree.get_first_node_in_group("player") as PlayerActor
	if player == null:
		return

	for h in player.player_hints:
		if h != null:
			h.confidence = min(1.0, h.confidence + hint_bonus_confidence)
