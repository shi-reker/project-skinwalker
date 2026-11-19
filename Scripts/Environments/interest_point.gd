extends TextureButton
class_name InterestButton

var events = preload("res://Scenes/Environments/event_button.tscn")
@export var grid:VBoxContainer
@export var dialogueHandler:DialogueComponent
var isPressed:bool = false
var storedLine:int = -1
var chosenEvent:EventButton

func _ready() -> void:
	var nEvents = 3
	for e in nEvents:
		var newEvent:EventButton = events.instantiate()
		newEvent.start_dialogue.connect(dialogueHandler.recieve_dialogue)
		grid.add_child(newEvent)
		newEvent.hide()
	print_debug(len(grid.get_children()))
	chosenEvent = grid.get_children()[randi_range(0, nEvents-1)]

func store_dialogue(line:int):
	storedLine = line

func _on_pressed() -> void:
	if !isPressed:
		chosenEvent.show()
		if storedLine != -1:
			dialogueHandler.dialogueBox.show()
			dialogueHandler.recieve_dialogue(chosenEvent.event.dialogue, storedLine)
		isPressed = true
	else:
		store_dialogue(dialogueHandler.current_line_index)
		chosenEvent.hide()
		dialogueHandler.dialogueBox.hide()
		isPressed = false
