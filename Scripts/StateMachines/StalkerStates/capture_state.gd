extends ActorState
class_name CaptureState

@export var capture_duration: float = 2.0

var _timer: float = 0.0
var stalker: StalkerActor

func enter(previous_state: StringName) -> void:
	print("[CaptureState] Player tertangkap!")
	_timer = capture_duration
	stalker_manager.debug_label.text = str(self.name)

	print_debug("HI THERE")
	Events.player_captured.emit()
	#var stalker := actor as StalkerActor
	#if stalker != null:
		#stalker.movement_component.stop_movement()
func exit(_next_state: StringName) -> void:
	_timer = 0.0


func update_state(delta: float) -> void:
	_timer -= delta
	if _timer <= 0.0:
		switch_state.emit(actor.get_node("StateMachine/SearchState"))
