extends NPCAbility
class_name AbilityObserver

var _houses_watched:Array[House]
var _distraction_timer: float = 0.0
var _distraction_position: Vector2

func _on_activate(_world: World) -> void:
	pass

func _on_use() -> void:
	pass

func _on_update(delta: float) -> void:
	if _is_using:
		#_target.velocity = Vector2.ZERO
		_distraction_timer -= delta
		if _distraction_timer <= 0.0:
			deactivate()

func _on_deactivate() -> void:
	pass
