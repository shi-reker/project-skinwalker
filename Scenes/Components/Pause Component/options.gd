extends Control

signal closed

func _ready() -> void:
	# Your volume and display initialization here
	pass

func _on_back_button_pressed() -> void:
	closed.emit()
	queue_free()
