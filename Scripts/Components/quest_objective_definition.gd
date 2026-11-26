extends Resource
class_name QuestObjectiveDefinition

@export var id: QuestManager.QuestObjectiveId = QuestManager.QuestObjectiveId.NONE
@export var target_item_id: ItemManager.ItemsId = ItemManager.ItemsId.NONE
@export var target_npc_id: NpcManager.NpcId = NpcManager.NpcId.NONE
@export_range(1, 999) var required_count: int = 1
