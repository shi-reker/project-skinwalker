extends Node
class_name House

var number: int
@export var color: EnvironmentManager.HouseColor
@export var street: Street

@export var interactable: InteractableComponent

@export var is_home: bool = false:
	set(value):
		is_home = value
		if value == false:
			return
		setup_home()

#func get_home() -> HomeComponent:
	#var home_component_
	#return null

func setup_home():
	interactable.interact_name = "GO HOME"
	interactable.interact = enter_home
	interactable.is_interactable = is_home_unlocked()

func enter_home() -> void:
	Events.home_entered.emit()

func is_home_unlocked() -> bool:
	return true
