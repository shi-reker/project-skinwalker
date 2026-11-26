extends Node
class_name QuestComponent

@export var quest_definition: QuestDefinition = null
var dialogue_status: DialogueManager.DialogueStatus = DialogueManager.DialogueStatus.NEVER
var npc: NPCActor = null
signal quest_completed

func setup(definition: QuestDefinition, owner: NPCActor) -> void:
	quest_definition = definition
	npc = owner
	if not quest_completed.is_connected(npc._on_quest_completed):
		quest_completed.connect(npc._on_quest_completed, CONNECT_ONE_SHOT)
 
func check_quest_progress() -> DialogueManager.DialogueStatus:
	if quest_definition == null:
		return dialogue_status
	if QuestManager.is_quest_completed(quest_definition):
		dialogue_status = DialogueManager.DialogueStatus.DONE
		quest_completed.emit()
		return dialogue_status
	if QuestManager.get_quest_status(quest_definition.id) == QuestManager.QuestStatus.ACTIVE:
		dialogue_status = DialogueManager.DialogueStatus.QUEST
	return dialogue_status

func offer_quest() -> bool:
	if quest_definition == null:
		return false
	return QuestManager.offer_quest(quest_definition)
