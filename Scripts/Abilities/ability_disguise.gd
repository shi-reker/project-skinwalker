extends NPCAbility
class_name AbilityDisguise

@export var disguise_duration: float = 8.0
@export var disguise_alpha: float = 0.4

var _timer: float = 0.0
var _player: PlayerActor = null
var _original_modulate: Color


#func _on_activate(_context: Dictionary) -> void:
	#_player = get_tree().get_first_node_in_group("player") as PlayerActor
	#if _player == null:
		#deactivate()
		#return
#
	#_timer = disguise_duration
	#_player.is_disguised = true
#
	## Visual feedback
	#var sprite := _player.get_node_or_null("Sprite2D") as Sprite2D
	#if sprite:
		#_original_modulate = sprite.modulate
		#sprite.modulate = Color(1, 1, 1, disguise_alpha)
#
	#print("[AbilityDisguise] Player disamarkan selama ", disguise_duration, "s")
#
#
#func _on_update(delta: float) -> void:
	#_timer -= delta
	#if _timer <= 0.0:
		#deactivate()
#
#
#func _on_deactivate() -> void:
	#if _player != null and is_instance_valid(_player):
		#_player.is_disguised = false
		#var sprite := _player.get_node_or_null("Sprite2D") as Sprite2D
		#if sprite:
			#sprite.modulate = _original_modulate
	#_player = null
	#_start_cooldown()
	#print("[AbilityDisguise] Samaran berakhir")
