extends Node

var dialogue_box: DialogueBox

func setup(dialogue_box_node: DialogueBox):
	dialogue_box = dialogue_box_node

func show_dialogue():
	dialogue_box.show()

func update_speaker(text: String, component: DialogueComponent):
	dialogue_box.speakerBox.show()
	dialogue_box.speakerText.text = text

func update_dialogue(text: String, component: DialogueComponent):
	dialogue_box.text.text = text

func update_choices(nChoices: int, choices: Array, component: DialogueComponent):
	for c in nChoices:
		dialogue_box.choices[c].show()
		dialogue_box.choices[c].id = c
		dialogue_box.choices[c].text.text = choices[c]
		dialogue_box.choices[c].picked.connect(component.dialogue_choice_handler)
		
func hide_dialogue():
	dialogue_box.hide()

func disable_dialogue():
	dialogue_box.disabled = true

func enable_dialogue():
	dialogue_box.disabled = false
