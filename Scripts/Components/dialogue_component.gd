extends Node
class_name DialogueComponent

signal dialogue_finished

@export var dialogue_definition: DialogueDefinition = null
@export var dialogueBox:DialogueBox
var current_line_index: int = 0
var is_dialogue_active: bool = false

func recieve_dialogue(dialogueRes:DialogueDefinition, line:int = 0):
	dialogue_definition = dialogueRes
	current_line_index = line
	start_dialogue()

func start_dialogue() -> void:
	#current_line_index = 0
	DialogueManager.show_dialogue()

	if dialogue_definition.speaker_name != "":
		DialogueManager.update_speaker(dialogue_definition.speaker_name, self)
	DialogueManager.update_dialogue(dialogue_definition.dialogue_lines[current_line_index], self)
	
	if current_line_index in dialogue_definition.choice_lines:
		var nChoices:int = len(dialogue_definition.choice_lines[current_line_index])/2
		var choices:Array = dialogue_definition.choice_lines[current_line_index]

		DialogueManager.update_choices(nChoices, choices, self)
		
		# for c in nChoices:
		# 	dialogueBox.choices[c].show()
		# 	dialogueBox.choices[c].id = c
		# 	dialogueBox.choices[c].text.text = choices[c]
		# 	dialogueBox.choices[c].picked.connect(dialogue_choice_handler)

func advance_dialogue() -> void:
	current_line_index += 1
	if !dialogue_definition.dialogue_lines.has(current_line_index):
		end_dialogue()
		return
	DialogueManager.update_dialogue(dialogue_definition.dialogue_lines[current_line_index], self)
	
	if dialogue_definition.choice_lines.has(current_line_index):
		dialogueBox.disabled = true
		var nChoices:int = len(dialogue_definition.choice_lines[current_line_index])/2
		var choices:Array = dialogue_definition.choice_lines[current_line_index]
		
		DialogueManager.update_choices(nChoices, choices, self)

		# for c in nChoices:
		# 	dialogueBox.choices[c].show()
		# 	dialogueBox.choices[c].id = c
		# 	dialogueBox.choices[c].text.text = choices[c]
		# 	dialogueBox.choices[c].picked.connect(dialogue_choice_handler)

func end_dialogue() -> void:
	DialogueManager.hide_dialogue()

func dialogue_choice_handler(id:int):
	DialogueManager.enable_dialogue()
	var offset = len(dialogue_definition.choice_lines[current_line_index])/2
	var nextLine:int = dialogue_definition.choice_lines[id][offset]
	dialogue_definition.end_lines[nextLine].call()

# var dialogue_lines: Array[String] = []

# var dialogue_layer: CanvasLayer
# var dialogue_panel: PanelContainer
# var speaker_label: Label
# var dialogue_text: Label
# var next_button: Button


# func _ready() -> void:
# 	create_dialogue_ui()


# func create_dialogue_ui() -> void:
# 	dialogue_layer = CanvasLayer.new()
# 	dialogue_layer.layer = 10
# 	add_child(dialogue_layer)

# 	dialogue_panel = PanelContainer.new()
# 	dialogue_panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
# 	dialogue_panel.offset_left = 30
# 	dialogue_panel.offset_top = -160
# 	dialogue_panel.offset_right = -30
# 	dialogue_panel.offset_bottom = -20
# 	dialogue_layer.add_child(dialogue_panel)

# 	var container = VBoxContainer.new()
# 	dialogue_panel.add_child(container)

# 	speaker_label = Label.new()
# 	speaker_label.text = "NPC"
# 	container.add_child(speaker_label)

# 	dialogue_text = Label.new()
# 	dialogue_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
# 	dialogue_text.custom_minimum_size = Vector2(0, 55)
# 	container.add_child(dialogue_text)

# 	next_button = Button.new()
# 	next_button.text = "Next (E)"
# 	# KUNCI: jangan biarkan Button merebut fokus keyboard
# 	next_button.focus_mode = Control.FOCUS_NONE
# 	next_button.pressed.connect(advance_dialogue)
# 	container.add_child(next_button)

# 	dialogue_panel.hide()


# func start_dialogue(custom_definition: DialogueDefinition = null) -> void:
# 	if is_dialogue_active:
# 		return

# 	var def_to_use: DialogueDefinition = custom_definition if custom_definition != null else dialogue_definition

# 	dialogue_lines.clear()
# 	current_line_index = 0

# 	if def_to_use != null:
# 		speaker_label.text = def_to_use.speaker_name
# 		for line in def_to_use.dialogue_lines:
# 			dialogue_lines.append(line)

# 	if dialogue_lines.is_empty():
# 		speaker_label.text = "NPC"
# 		dialogue_lines.append("Halo! Senang bertemu denganmu.")
# 		dialogue_lines.append("Sampai jumpa!")

# 	is_dialogue_active = true
# 	dialogue_panel.show()
# 	show_current_line()


# func show_current_line() -> void:
# 	if current_line_index >= 0 and current_line_index < dialogue_lines.size():
# 		dialogue_text.text = dialogue_lines[current_line_index]
# 		next_button.text = "Selesai (E)" if current_line_index == dialogue_lines.size() - 1 else "Next (E)"


# func advance_dialogue() -> void:
# 	if not is_dialogue_active:
# 		return

# 	current_line_index += 1

# 	if current_line_index >= dialogue_lines.size():
# 		end_dialogue()
# 		return

# 	show_current_line()


# func end_dialogue() -> void:
# 	is_dialogue_active = false
# 	current_line_index = 0
# 	dialogue_panel.hide()
# 	dialogue_finished.emit()

# func _unhandled_input(event: InputEvent) -> void:
# 	if not is_dialogue_active:
# 		return

# 	if event.is_action_pressed("interact"):
# 		advance_dialogue()
# 		get_viewport().set_input_as_handled()
