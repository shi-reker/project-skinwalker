extends CharacterBody2D
class_name PlayerActor

@onready var movement: MovementComponent = $Components/MovementComponent
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var interact_pop_up: Control = $InteractPopUp

signal entered_home
signal interaction_requested

var _interaction_available: bool = false

func _ready() -> void:
	state_machine.setup(self)
	interact_pop_up.hide()

func set_interaction_available(available: bool) -> void:
	_interaction_available = available
	interact_pop_up.visible = available

func _unhandled_input(event: InputEvent) -> void:
	if _interaction_available and event.is_action_pressed("interact"):
		interaction_requested.emit()
		get_viewport().set_input_as_handled()
