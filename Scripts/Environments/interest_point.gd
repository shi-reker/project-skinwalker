extends TextureButton
class_name InterestButton

var events = preload("res://Scenes/Environments/event_button.tscn")
@export var grid:VBoxContainer
var isPressed:bool = false

func _ready() -> void:
	var nEvents = randi_range(1, 3)
	print_debug(nEvents)
	
	for e in nEvents:
		var newEvent:EventButton = events.instantiate()
		grid.add_child(newEvent)
		newEvent.hide()

func _on_pressed() -> void:
	if !isPressed:
		for child in grid.get_children():
			child.show()
		isPressed = true
	else:
		for child in grid.get_children():
			child.hide()
		isPressed = false
