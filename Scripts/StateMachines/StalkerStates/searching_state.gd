extends ActorState
class_name SearchingState

@export var noise:AudioStreamPlayer2D

func update_state(delta: float) -> void:
	noise.play()
	await  noise.finished

func exit(next_state: StringName) -> void:
	noise.stop()
