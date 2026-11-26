extends CharacterBody2D
class_name NPCActor

signal recruited(npc: NPCActor)
signal ability_used(npc: NPCActor, ability: NPCAbility)

@export var npc_definition: NPCDefinition

@onready var movement_component: MovementComponent = $Components/MovementComponent
@onready var dialogue_component: DialogueComponent = $Components/DialogueComponent
@export var quest_component: QuestComponent
@onready var follow_component: FollowComponent = $Components/FollowComponent
@onready var state_machine: NPCStateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var interactable: InteractableComponent = $InteractableComponent

var is_recruited: bool = false
var has_talked_once: bool = false

func _ready() -> void:
	setup_npc()
	
	interactable.interact_name = "Talk"
	interactable.interact = interact_with_player
	
	dialogue_component.dialogue_finished.connect(_on_dialogue_finished)
	dialogue_component.quest_requested.connect(_on_quest_requested)

	if npc_definition != null and npc_definition.ability != null:
		npc_definition.ability = npc_definition.ability.duplicate(true)
		npc_definition.ability.setup(self)

	NpcManager.register_npc(self)

func _exit_tree() -> void:
	if NpcManager:
		NpcManager.unregister_npc(self)

func _physics_process(delta: float) -> void:
	# Update ability aktif
	if npc_definition != null and npc_definition.ability != null:
		npc_definition.ability.update(delta)

func setup_npc() -> void:
	if npc_definition == null:
		return

	dialogue_component.npc = self
	quest_component.setup(npc_definition.quest_definition, self)

	if npc_definition.texture != null:
		sprite.texture = npc_definition.texture

	if npc_definition.dialogue_definition != null:
		DebugManager.add_debug("FOUND DIALOGUE"+str(npc_definition.dialogue_definition))
		dialogue_component.dialogue_definition = npc_definition.dialogue_definition

	if npc_definition.movement_definition != null:
		movement_component.movement_definition = npc_definition.movement_definition

func interact_with_player() -> void:
	if dialogue_component.is_dialogue_active:
		return

	QuestManager.record_actor_interaction(npc_definition.id)
	
	if is_recruited:
		dialogue_component.update_status(DialogueManager.DialogueStatus.RECRUITED)
		dialogue_component.start_dialogue()
		return

	dialogue_component.update_status(quest_component.check_quest_progress())
	
	if not has_talked_once:
		dialogue_component.start_dialogue()
		has_talked_once = true
	else:
		if can_recruit_now():
			dialogue_component.recieve_dialogue(npc_definition.recruitment_dialogue)
		else:
			dialogue_component.start_dialogue()

func has_ability() -> bool:
	return npc_definition != null and npc_definition.ability != null

func can_use_ability() -> bool:
	if not is_recruited or not has_ability():
		return false
	return npc_definition.ability.can_activate()


func use_ability(context: Dictionary = {}) -> bool:
	if not can_use_ability():
		print("[NPC] Ability tidak tersedia untuk ", name)
		return false
	#npc_definition.ability.activate(context)
	ability_used.emit(self, npc_definition.ability)
	print("[NPC] ", name, " menggunakan ability: ", npc_definition.ability.ability_name)
	return true

func can_recruit_now() -> bool:
	if npc_definition == null or not npc_definition.can_be_recruited:
		return false

	return true

func recruit() -> void:
	if is_recruited:
		return
	is_recruited = true
	dialogue_component.status = DialogueManager.DialogueStatus.RECRUITED
	print_debug("RECRUITED!!!! ", dialogue_component.status)
	NpcManager._on_npc_recruited(self)

func _on_quest_requested() -> void:
	quest_component.offer_quest()

func _on_quest_completed() -> void:
	# dialogue_component.update_status(DialogueManager.DialogueStatus.DONE)
	pass

func _on_dialogue_finished(dialogue_status: DialogueManager.DialogueStatus) -> void:
	if dialogue_status == DialogueManager.DialogueStatus.QUEST:
		pass
	elif dialogue_status == DialogueManager.DialogueStatus.DONE and !is_recruited:
		recruit()
