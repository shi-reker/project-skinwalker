extends TextureButton
class_name EventButton

@export var event:EventBase
@export var title:Label

signal start_dialogue(d:DialogueDefinition, line:int)

func _ready() -> void:
	Setup()

func Setup():
	title.text = event.eventName

func _on_pressed() -> void:
	start_dialogue.emit(event.dialogue, 0)
	disabled = true
	print_debug("event")
