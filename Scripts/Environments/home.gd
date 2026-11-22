extends Node2D
class_name HomeComponent

func setup(interactable: InteractableComponent):
	interactable.interact_name = "GO HOME"
	interactable.interact = enter_home
	interactable.is_interactable = is_home_unlocked()

func enter_home() -> void:
	Events.home_entered.emit()

func is_home_unlocked() -> bool:
	return true
