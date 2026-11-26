extends Node

enum QuestId { NONE, MAYA_LOCKET, FIND_KEY, ESCORT_NPC, FIND_CLOTHES }
enum QuestObjectiveId { NONE, PICKUP, INTERACT }
enum QuestStatus { NOT_STARTED, ACTIVE, COMPLETED }

var quest_resource: Dictionary[QuestId, QuestDefinition] = {
	QuestId.NONE: preload("res://Resources/Quests/fetch_spare_key.tres"),
	QuestId.MAYA_LOCKET: preload("res://Resources/Quests/fetch_spare_key.tres"),
	QuestId.FIND_KEY: preload("res://Resources/Quests/fetch_spare_key.tres"),
	QuestId.ESCORT_NPC: preload("res://Resources/Quests/fetch_spare_key.tres"),
	QuestId.FIND_CLOTHES: preload("res://Resources/Quests/fetch_clothes.tres")
}

var quest_statuses: Dictionary[QuestId, QuestStatus] = {}
var quest_progress: Dictionary[QuestId, int] = {}
var item_quests: Dictionary[ItemManager.ItemsId, QuestId] = {}
var npc_quests: Dictionary[NpcManager.NpcId, QuestId] = {}
var quest_display: QuestsDisplay

func setup(_quest_display: QuestsDisplay):
	quest_display = _quest_display
	setup_quests_display()

func offer_quest(definition: QuestDefinition) -> bool:
	if definition == null or definition.id == QuestId.NONE:
		return false
	if quest_statuses.get(definition.id, QuestStatus.NOT_STARTED) != QuestStatus.NOT_STARTED:
		return false
	
	var objective: QuestObjectiveId = definition.objective
	quest_resource[definition.id] = definition
	quest_statuses[definition.id] = QuestStatus.ACTIVE
	
	if objective == QuestObjectiveId.PICKUP:
		quest_progress[definition.id] = int(ItemManager.item_quantities.get(definition.target_item_id, 0))
		item_quests[definition.target_item_id] = definition.id
		ItemManager.spawn_item(definition.target_item_id)
	elif objective == QuestObjectiveId.INTERACT:
		quest_progress[definition.id] = 0
		npc_quests[definition.target_npc_id] = definition.id
	_check_completed(definition)
	return true

func record_actor_interaction(actor_id: NpcManager.NpcId) -> void:
	if npc_quests.has(actor_id):
		var quest_id: QuestId = npc_quests[actor_id]
		quest_progress[quest_id] = 1
		_check_completed(quest_resource[quest_id])

func get_quest_status(quest_id: QuestId) -> int:
	return int(quest_statuses.get(quest_id, QuestStatus.NOT_STARTED))

func is_quest_completed(quest: QuestDefinition) -> bool:
	return quest != null and get_quest_status(quest.id) == QuestStatus.COMPLETED

func _on_item_accepted(item: ItemDefinition, quantity: int) -> void:
	if not item_quests.has(item.id):
		return
	var quest_id: QuestId = item_quests[item.id]
	var def: QuestDefinition = quest_resource[quest_id]
	quest_progress[quest_id] = mini(quantity, def.required_count)
	print_debug("quest progress: %d/%d" % [quest_progress[quest_id], def.required_count])
	_check_completed(def)


func _check_completed(definition: QuestDefinition) -> void:
	var quest_id := definition.id
	print_debug("checking quest completion for %s" % [definition.title])
	if int(quest_progress.get(quest_id, 0)) >= definition.required_count:
		quest_statuses[quest_id] = QuestStatus.COMPLETED
	if quest_display != null:
		quest_display.update_quest(definition, int(quest_progress.get(quest_id, 0)))

func setup_quests_display():
	if quest_display == null:
		return
	quest_display.setup()
	for quest_id in quest_progress:
		quest_display.update_quest(
			quest_resource[quest_id],
			int(quest_progress[quest_id])
		)
