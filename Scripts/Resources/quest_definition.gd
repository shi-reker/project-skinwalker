extends Resource
class_name QuestDefinition

@export var id: QuestManager.QuestId = QuestManager.QuestId.NONE
@export var objectives: Array[QuestObjectiveDefinition] = []
