extends Resource
class_name NPCDefinition

@export var id: NpcManager.NpcId = NpcManager.NpcId.NONE
@export var display_name: String = ""
@export var behavior_definition: NPCBehaviorDefinition
@export var movement_definition: MovementDefinition
@export var dialogue_definition: DialogueDefinition
@export var texture: Texture2D
@export var quest_definition: QuestDefinition = null

@export_group("Recruitment")
@export var can_be_recruited: bool = true
@export var recruitment_required_hints: Array[HintDefinition] = []
@export var recruitment_min_confidence: float = 0.0
@export var recruitment_dialogue: DialogueDefinition
@export var follow_distance: float = 60.0

@export_group("Ability")
@export var ability: NPCAbility
@export var ability_input_action: StringName = &"ability"
@export var location: Vector2 = Vector2(0,0)
