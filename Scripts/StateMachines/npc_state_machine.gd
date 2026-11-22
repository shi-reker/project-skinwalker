extends StateMachine
class_name NPCStateMachine

enum State {
	IDLE,
	WANDERING,
	INTERACTING,
	INVESTIGATING,
}

#@export var initial_state: State = State.IDLE
var current_state_id: State = State.IDLE

func _ready() -> void:
	pass
	#initial_state = State.IDLE
