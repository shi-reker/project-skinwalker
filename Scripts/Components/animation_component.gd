extends AnimatedSprite2D
class_name AnimationComponent

func _on_movement_direction_changed(direction: Vector2, anim_has_dir: bool = true, anim_has_idle: bool = false) -> void:
	if direction == Vector2.ZERO:
		if anim_has_idle:
			animation = "idle"
			return
		stop()
		return

	var animation_name: StringName
	if !anim_has_dir:
		animation_name = "move"
	elif abs(direction.x) > abs(direction.y):
		animation_name = "right" if direction.x > 0.0 else "left"
	else:
		animation_name = "down" if direction.y > 0.0 else "up"

	if animation != animation_name or not is_playing():
		play(animation_name)
