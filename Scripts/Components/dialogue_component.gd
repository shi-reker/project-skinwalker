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
	
	if dialogue_definition.choice_lines[current_line_index]:
		var nChoices:int = len(dialogue_definition.choice_lines[current_line_index])/2
		var choices:Array = dialogue_definition.choice_lines[current_line_index]
		
		for c in nChoices:
			dialogueBox.choices[c].show()
			dialogueBox.choices[c].id = c
			dialogueBox.choices[c].text.text = choices[c]
			dialogueBox.choices[c].picked.connect(dialogue_choice_handler)

func advance_dialogue() -> void:
	current_line_index += 1
	dialogueBox.text.text = dialogue_definition.dialogue_lines[current_line_index]
	
	if dialogue_definition.choice_lines[current_line_index]:
		dialogueBox.disabled = true
		var nChoices:int = len(dialogue_definition.choice_lines[current_line_index])/2
		var choices:Array = dialogue_definition.choice_lines[current_line_index]
		
		for c in nChoices:
			dialogueBox.choices[c].show()
			dialogueBox.choices[c].id = c
			dialogueBox.choices[c].text.text = choices[c]
			dialogueBox.choices[c].picked.connect(dialogue_choice_handler)

func end_dialogue() -> void:
	dialogueBox.hide()

func dialogue_choice_handler(id:int):
	dialogueBox.disabled = false
	var offset = len(dialogue_definition.choice_lines[current_line_index])/2
	var nextLine:int = dialogue_definition.choice_lines[id][offset]
	dialogue_definition.end_lines[nextLine].call()
