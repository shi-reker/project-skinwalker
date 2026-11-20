extends Node

enum QuestId { NONE, MAYA_LOCKET, FIND_KEY, ESCORT_NPC }

var quest_resource: Dictionary[QuestId, Resource] = {
	QuestId.NONE: preload("res://Resources/Quests/fetch_spare_key.tres"), 
	QuestId.MAYA_LOCKET: preload("res://Resources/Quests/fetch_spare_key.tres"), 
	QuestId.FIND_KEY: preload("res://Resources/Quests/fetch_spare_key.tres"), 
	QuestId.ESCORT_NPC: preload("res://Resources/Quests/fetch_spare_key.tres")
}

enum QuestObjectiveId {
	NONE, PICKUP, INTERACT
}

var objective_resource: Dictionary[QuestObjectiveId, Resource] = {
	QuestObjectiveId.NONE: preload("res://Resources/Quests/collect_objective.tres"),
	QuestObjectiveId.PICKUP: preload("res://Resources/Quests/collect_objective.tres"),
	QuestObjectiveId.INTERACT: preload("res://Resources/Quests/collect_objective.tres"),
}

enum QuestStatus {
	NOT_STARTED,
	ACTIVE,
	COMPLETED,
}

var quest_statuses: Dictionary[QuestId, QuestStatus] = {}

signal quest_accepted(quest: QuestDefinition)
func offer_quest(definition: QuestDefinition) -> bool:
	if definition == null or definition.id == QuestId.NONE:
		push_error("Cannot offer a quest without a definition and quest ID.")
		return false
	var quest_id := definition.id
	quest_statuses[quest_id] = QuestStatus.ACTIVE
	quest_accepted.emit(definition)
	return true
