extends ActorState
class_name CaptureState

@export var capture_duration: float = 2.0

var _timer: float = 0.0
var stalker: StalkerActor

func enter(_previous_state: StringName) -> void:
	print("[CaptureState] Player tertangkap!")
	_timer = capture_duration

	var world := get_tree().current_scene
	if world and world.has_method("on_player_captured"):
		world.on_player_captured()


func exit(_next_state: StringName) -> void:
	_timer = 0.0


func update_state(delta: float) -> void:
	_timer -= delta
	if _timer <= 0.0:
		switch_state.emit(actor.get_node("StateMachine/SearchState"))
