extends Resource
class_name DialogueDefinition
signal check_quest()
@export var speaker_name: String = ""
@export var dialogue_lines: Array[String]
@export var choice_lines: Dictionary[int, Array]
@export var end_lines: Dictionary[int, DialogueManager.DialogueAction]
@export var start_lines: Dictionary[DialogueManager.DialogueStatus, int] = {
	DialogueManager.DialogueStatus.NEVER : 0
}

func setup():
	push_error("define choice_lines and end_lines!!!!")
