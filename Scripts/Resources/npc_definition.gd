extends Resource
class_name NPCDefinition

@export var id: NpcManager.NpcId = NpcManager.NpcId.NONE
@export var display_name: String = ""
@export var behavior_definition: NPCBehaviorDefinition
@export var movement_definition: MovementDefinition
@export var dialogue_definition: DialogueDefinition
@export var texture: Texture2D
@export var quest_definition: QuestDefinition = null
