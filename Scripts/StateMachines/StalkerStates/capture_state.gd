extends ActorState
class_name CaptureState

var stalker: StalkerActor

func enter(previous_state: StringName) -> void:
	print_debug("HI THERE")
	Events.player_captured.emit()
	#var stalker := actor as StalkerActor
	#if stalker != null:
		#stalker.movement_component.stop_movement()

func exit(next_state: StringName) -> void:
	pass

func update_state(delta: float) -> void:
	pass
