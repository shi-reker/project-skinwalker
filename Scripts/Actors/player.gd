extends CharacterBody2D
class_name PlayerActor

@onready var movement_component: MovementComponent = $Components/MovementComponent
@onready var state_machine: PlayerStateMachine = $StateMachine
func _ready() -> void:
	state_machine.setup(self)
