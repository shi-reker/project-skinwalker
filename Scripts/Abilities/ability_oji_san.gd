extends NPCAbility
class_name AbilityOjiSan

@export var reveal_radius: float = 600.0
@export var home_hint_value: String = "Rumah ada di arah timur laut"

var _revealed_home: Node2D = null


#func _on_activate(_context: Dictionary) -> void:
	#if not _context.has("player"):
		#return
	#var player := _context["player"] as PlayerActor
#
	#if player == null:
		#return
#
	#_revealed_home = _find_home_node()
	#if _revealed_home == null:
		#print("[AbilityOjiSan] Tidak ada Home di scene!")
		#return
#
	## Beri hint rumah ke player
	#var hint := HintDefinition.new()
	#hint.category = HintDefinition.HintCategory.HOUSE_COLOR
	#hint.hint_value = home_hint_value
	#hint.confidence = 0.9
	#hint.is_active = true
	#player.add_hint(hint)
#
	## Visual: garis sementara ke rumah
	#_draw_path_to_home(player)
#
	#print("[AbilityOjiSan] Rumah ditunjukkan: ", _revealed_home.global_position)
	#deactivate()
#
#
#func _on_deactivate() -> void:
	#_start_cooldown()
#
#
#func _find_home_node() -> Node2D:
	#var npc := get_owner_npc()
	#if npc == null:
		#return null
	#var tree := npc.get_tree()
	#if tree == null:
		#return null
#
	#for node in tree.get_nodes_in_group("home"):
		#if node is Node2D:
			#return node
#
	#EnvironmentManager.home_node
	#return null
#
#
#func _draw_path_to_home(player: PlayerActor) -> void:
	#if _revealed_home == null:
		#return
	#var line := Line2D.new()
	#line.add_point(player.global_position)
	#line.add_point(_revealed_home.global_position)
	#line.width = 3.0
	#line.default_color = Color(1, 0.8, 0.2, 0.7)
	#player.get_parent().add_child(line)
	#player.get_tree().create_timer(3.0).timeout.connect(func():
		#if is_instance_valid(line):
			#line.queue_free()
	#)
