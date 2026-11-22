extends Area2D
class_name InteractableComponent

@export var interact_name: String = ""
@export var is_interactable: bool = true

var interact: Callable


func _ready() -> void:
	interact = func():
		pass


func interact_with_player() -> void:
	if !is_interactable:
		return

	if interact.is_valid():
		interact.call()
