extends Node

var dialogue_box: DialogueBox
var _is_any_dialogue_active: bool = false
var _active_component: DialogueComponent = null

enum DialogueStatus { NEVER, QUEST, DONE, RECRUITED }
enum DialogueAction { NONE, QUEST, RECRUIT }

var dialogue_statuses: Dictionary[DialogueDefinition, DialogueStatus] = {}

func setup(dialogue_box_node: DialogueBox):
	dialogue_box = dialogue_box_node

func begin_session(component: DialogueComponent) -> void:
	_active_component = component
	dialogue_box.pressed.connect(component.advance_dialogue)

func end_session(component: DialogueComponent) -> void:
	if _active_component == component:
		_active_component = null

func show_dialogue():
	_is_any_dialogue_active = true
	dialogue_box.show()

func update_speaker(text: String, component: DialogueComponent):
	dialogue_box.speakerBox.show()
	dialogue_box.speakerText.text = text

func hide_speaker() -> void:
	dialogue_box.speakerBox.hide()

func update_dialogue(text: String, component: DialogueComponent):
	dialogue_box.text.text = text

func update_choices(nChoices: int, choices: Array, component: DialogueComponent):
	DebugManager.add_debug("found choice\n")
	hide_choices()
	for c in range(nChoices):
		var btn = dialogue_box.choices[c]
		btn.show()
		btn.id = c
		btn.text.text = str(choices[c])
		if not btn.picked.is_connected(component.dialogue_choice_handler):
			btn.picked.connect(component.dialogue_choice_handler, CONNECT_ONE_SHOT)
			DebugManager.add_debug(str("connected choice "+str(c)+"\n"))

func hide_choices() -> void:
	for btn in dialogue_box.choices:
		btn.hide()
		if _active_component != null and btn.picked.is_connected(_active_component.dialogue_choice_handler):
			btn.picked.disconnect(_active_component.dialogue_choice_handler)

func hide_dialogue():
	_is_any_dialogue_active = false
	dialogue_box.hide()

func disable_dialogue():
	dialogue_box.disabled = true

func enable_dialogue():
	dialogue_box.disabled = false
