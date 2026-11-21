extends ActorState
class_name CaptureState

func enter(previous_state: StringName) -> void:
	var stalker := actor as StalkerActor
	if stalker != null:
		stalker.movement_component.stop_movement()

func exit(next_state: StringName) -> void:
	pass

func update_state(delta: float) -> void:
	print_debug(delta)
