extends ActorState
class_name SurveilState

var stalker: StalkerActor

func enter(previous_state: StringName) -> void:
	pass

func exit(next_state: StringName) -> void:
	pass

func update_state(delta: float) -> void:
	pass
