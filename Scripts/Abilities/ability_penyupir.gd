extends NPCAbility
class_name AbilityPenyupir

@export var teleport_target_group: String = "home"
@export var fade_duration: float = 0.5
@export var cooldown_extra: float = 15.0

var _is_teleporting: bool = false


func _on_activate(_context: Dictionary) -> void:
	var player := get_tree().get_first_node_in_group("player") as PlayerActor
	if player == null:
		deactivate()
		return

	var destination := _find_destination()
	if destination == null:
		print("[AbilityPenyupir] Tidak ada tujuan teleport!")
		deactivate()
		return

	_is_teleporting = true
	_teleport_with_fade(player, destination)


func _on_deactivate() -> void:
	cooldown = 5.0 + cooldown_extra
	_start_cooldown()
	_is_teleporting = false
	print("[AbilityPenyupir] Selesai, cooldown ", cooldown, "s")


func _find_destination() -> Node2D:
	for node in get_tree().get_nodes_in_group(teleport_target_group):
		if node is Node2D:
			return node
	return null


func _teleport_with_fade(player: PlayerActor, destination: Node2D) -> void:
	var sprite := player.get_node_or_null("Sprite2D") as Sprite2D
	var original := Color.WHITE
	if sprite:
		original = sprite.modulate

	# Fade out
	if sprite:
		var tween := create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, fade_duration)
		await tween.finished

	# Teleport
	player.global_position = destination.global_position

	# Fade in
	if sprite:
		var tween2 := create_tween()
		tween2.tween_property(sprite, "modulate", original, fade_duration)
		await tween2.finished

	print("[AbilityPenyupir] Player diantar ke: ", destination.name)
	deactivate()