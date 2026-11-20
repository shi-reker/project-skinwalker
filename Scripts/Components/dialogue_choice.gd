extends TextureButton
class_name DialogueChoice

@export var text:Label
var id:int

signal picked(id:int)

func _on_pressed() -> void:
	picked.emit(id)
