extends CharacterBody2D
class_name PlayerActor

@onready var movement: MovementComponent = $Components/MovementComponent
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var interact_pop_up: Control = $InteractPopUp

signal entered_home
signal interaction_requested

var can_interact: bool = true
var cur_interactables: Array[InteractableComponent] = []

func _ready() -> void:
	state_machine.setup(self)
	interact_pop_up.hide()

func _physics_process(delta: float) -> void:
	movement.move_with_input(
		Input.get_vector("move_left", "move_right", "move_up", "move_down"),
		delta
	)
	var label: Label = $Label
	label.text = str(global_position)

func set_interaction_available(available: bool, position: Vector2 = global_position) -> void:
	can_interact = available
	interact_pop_up.visible = available
	interact_pop_up.global_position = position

func _unhandled_input(event: InputEvent) -> void:
	if can_interact and cur_interactables and event.is_action_pressed("interact"):
		can_interact = false
		cur_interactables[0].interact.call()
		get_viewport().set_input_as_handled()
		can_interact = true


func _on_detect_area_area_entered(area: Area2D) -> void:
	if area is InteractableComponent:
		set_interaction_available(true, area.global_position)
		cur_interactables.push_back(area)


func _on_detect_area_area_exited(area: Area2D) -> void:
	if area is InteractableComponent:
		cur_interactables.erase(area)
		if cur_interactables.is_empty():
			set_interaction_available(false)
		else:
			set_interaction_available(true, cur_interactables[0].global_position)
