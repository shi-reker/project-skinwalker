extends Node2D
class_name House

var number: int
@export var color: EnvironmentManager.HouseColor
@export var street: Street

@export var interactable: InteractableComponent
@export var is_home: bool = false

func _ready() -> void:
	EnvironmentManager.add_house(self)
	if is_home:
		add_to_group("home")
		setup_home()

func setup_home() -> void:
	if interactable == null:
		push_error("Home house is missing its InteractableComponent.")
		return
	interactable.interact_name = "GO HOME"
	interactable.interact = enter_home
	interactable.is_interactable = is_home_unlocked()

func enter_home() -> void:
	Events.home_entered.emit()

func is_home_unlocked() -> bool:
	return true
