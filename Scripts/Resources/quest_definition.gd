extends Resource
class_name QuestDefinition

@export var id: QuestManager.QuestId = QuestManager.QuestId.NONE
@export var title: String = ""
@export_multiline var description: String = ""
@export var objective: QuestManager.QuestObjectiveId = QuestManager.QuestObjectiveId.NONE
@export var target_item_id: ItemManager.ItemsId = ItemManager.ItemsId.NONE
@export var target_npc_id: NpcManager.NpcId = NpcManager.NpcId.NONE
@export_range(1, 999) var required_count: int = 1

func unlock():
	QuestManager.offer_quest(self)
