extends StaticBody2D
class_name Home

@export var interactable: InteractableComponent
signal home_entered


func _ready() -> void:
	add_to_group("home")
	if interactable:
		interactable.interact = func():
			home_entered.emit()