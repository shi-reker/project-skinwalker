extends TextureButton
class_name DialogueBox

@export var speakerBox:TextureRect
@export var speakerText:Label
@export var text:Label
@export var c1:DialogueChoice
@export var c2:DialogueChoice
@export var c3:DialogueChoice
@export var c4:DialogueChoice

var choices:Array [DialogueChoice]

func _ready() -> void:
	choices = [c1, c2, c3, c4]
	DialogueManager.setup(self)
