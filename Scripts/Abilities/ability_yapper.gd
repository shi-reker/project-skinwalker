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
