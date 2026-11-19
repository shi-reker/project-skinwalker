extends Node
class_name DialogueComponent

@export var dialogue_definition: DialogueDefinition
@export var dialogueBox:DialogueBox
var current_line_index: int = 0
var is_dialogue_active: bool = false

func recieve_dialogue(dialogueRes:DialogueDefinition, line:int):
	dialogue_definition = dialogueRes
	current_line_index = line
	start_dialogue()

func start_dialogue() -> void:
	#current_line_index = 0
	dialogueBox.show()
	if dialogue_definition.speaker_name != "":
		dialogueBox.speakerBox.show()
		dialogueBox.speakerText.text = dialogue_definition.speaker_name
	dialogueBox.text.text = dialogue_definition.dialogue_lines[current_line_index]

func advance_dialogue() -> void:
	current_line_index += 1
	dialogueBox.text.text = dialogue_definition.dialogue_lines[current_line_index]

func end_dialogue() -> void:
	dialogueBox.hide()
