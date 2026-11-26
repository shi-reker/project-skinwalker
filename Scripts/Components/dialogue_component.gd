extends Node
class_name DialogueComponent

signal dialogue_finished(status: DialogueManager.DialogueStatus)
signal quest_requested

@export var dialogue_definition: DialogueDefinition = null
@export var dialogueBox:DialogueBox
var current_line_index: int = 0
var is_dialogue_active: bool = false
var npc: NPCActor = null

var status: DialogueManager.DialogueStatus = DialogueManager.DialogueStatus.NEVER

func update_status(new_status: DialogueManager.DialogueStatus) -> void:
	status = new_status

func recieve_dialogue(dialogue_res: DialogueDefinition, line: int = 0) -> void:
	DebugManager.add_debug("got new dialogue!"+str(dialogue_res))
	if dialogue_res == null:
		return
	dialogue_definition = dialogue_res
	current_line_index = line
	start_dialogue()

func start_dialogue() -> void:
	#dialogue_definition.choice_lines = dialogue_definition.get_choices()
	if dialogue_definition == null or dialogue_definition.dialogue_lines.is_empty():
		return
	# if status is quest, check quest progress and update dialogue accordingly
	print_debug("status before checking is",status)
	if status == DialogueManager.DialogueStatus.QUEST:
		if npc != null and npc.quest_component != null and npc.quest_component.quest_definition != null:
			var quest_status: int = QuestManager.get_quest_status(npc.quest_component.quest_definition.id)
			if quest_status == QuestManager.QuestStatus.COMPLETED:
				status = DialogueManager.DialogueStatus.DONE
	is_dialogue_active = true
	current_line_index = clampi(current_line_index, 0, dialogue_definition.dialogue_lines.size() - 1)

	DialogueManager.begin_session(self)
	DialogueManager.show_dialogue()

	if dialogue_definition.speaker_name != "":
		DialogueManager.update_speaker(dialogue_definition.speaker_name, self)
	else:
		DialogueManager.hide_speaker()
	

	current_line_index = dialogue_definition.start_lines.get(
		status,
		dialogue_definition.start_lines.get(
			DialogueManager.DialogueStatus.NEVER,
			0
		)
	)
	print_debug("status is",status)
	_display_current_line()

func advance_dialogue() -> void:
	if not is_dialogue_active or dialogue_definition == null:
		return

	if dialogue_definition.end_lines.has(current_line_index):
		var action: DialogueManager.DialogueAction = dialogue_definition.end_lines[current_line_index]
		_run_end_action(action)
		end_dialogue(action)
		return

	current_line_index += 1

	if current_line_index >= dialogue_definition.dialogue_lines.size():
		end_dialogue()
		return

	_display_current_line()

func _run_end_action(action: DialogueManager.DialogueAction) -> void:
	if action == DialogueManager.DialogueAction.QUEST:
		quest_requested.emit()

func _display_current_line() -> void:
	print_debug("checkoing choice handler", current_line_index, " for ",dialogue_definition.choice_lines)
	DialogueManager.update_dialogue(dialogue_definition.dialogue_lines[current_line_index], self)

	if dialogue_definition.choice_lines.has(current_line_index):
		var choices: Array = dialogue_definition.choice_lines[current_line_index]
		var n_choices: int = choices.size() / 2
		DialogueManager.disable_dialogue()
		DialogueManager.update_choices(n_choices, choices, self)
	else:
		DialogueManager.enable_dialogue()
		DialogueManager.hide_choices()

func end_dialogue(action: DialogueManager.DialogueAction = DialogueManager.DialogueAction.NONE) -> void:
	if not is_dialogue_active:
		return

	if action == DialogueManager.DialogueAction.QUEST:
		status = DialogueManager.DialogueStatus.QUEST
	elif action == DialogueManager.DialogueAction.RECRUIT:
		status = DialogueManager.DialogueStatus.DONE

	is_dialogue_active = false
	current_line_index = 0
	DialogueManager.hide_choices()
	DialogueManager.hide_dialogue()
	DialogueManager.end_session(self)
	
	dialogue_finished.emit(status)

func dialogue_choice_handler(id:int):
	if current_line_index not in dialogue_definition.choice_lines:
		return

	var choices: Array = dialogue_definition.choice_lines[current_line_index]
	var offset: int = choices.size() / 2
	if id < 0 or id >= offset:
		return
	var target_key: int = choices[id + offset]
	DialogueManager.hide_choices()
	DialogueManager.enable_dialogue()
	if target_key >= 0 and target_key < dialogue_definition.dialogue_lines.size():
		current_line_index = target_key
		_display_current_line()
	else:
		end_dialogue()

func _unhandled_input(event: InputEvent) -> void:
	if not is_dialogue_active:
		return

	if event.is_action_pressed("interact"):
		advance_dialogue()
		get_viewport().set_input_as_handled()
