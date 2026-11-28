extends CharacterBody2D
class_name NPCActor

signal recruited(npc: NPCActor)
signal ability_used(npc: NPCActor, ability: NPCAbility)

@export var npc_definition: NPCDefinition
@export var quest_component: QuestComponent
@export var sprite: Sprite2D
@export var animation: AnimationComponent = null

@onready var detection_component: DetectionComponent = $Components/DetectionComponent
@onready var movement_component: MovementComponent = $Components/MovementComponent
@onready var dialogue_component: DialogueComponent = $Components/DialogueComponent
@onready var follow_component: FollowComponent = $Components/FollowComponent
@onready var interactable: InteractableComponent = $InteractableComponent
@onready var state_machine: NPCStateMachine = $StateMachine

var is_recruited: bool = false
var has_talked_once: bool = false

func _ready() -> void:
	setup_npc()
	
	interactable.interact_name = "Talk"
	interactable.interact = interact_with_player
	
	dialogue_component.dialogue_finished.connect(_on_dialogue_finished)
	dialogue_component.quest_requested.connect(_on_quest_requested)
	detection_component.stalker_detected.connect(_on_detected)
	detection_component.setup(self)

	if npc_definition != null:
		var frames: SpriteFrames = npc_definition.frames
		if frames != null:
			animation.sprite_frames = frames
			movement_component.direction_changed.connect(animation._on_movement_direction_changed)
		elif npc_definition.texture != null:
			sprite.texture = npc_definition.texture
		else:
			push_error("add visuals to npc def ", npc_definition.display_name)
		
		if npc_definition.ability != null:
			npc_definition.ability = npc_definition.ability.duplicate(true)
			npc_definition.ability.setup(self)
		
		if npc_definition.movement_definition != null:
			movement_component.setup(self, npc_definition.movement_definition)
		else:
			movement_component.setup(self)
	
	NpcManager.register_npc(self)

func _exit_tree() -> void:
	if NpcManager:
		NpcManager.unregister_npc(self)

func _physics_process(delta: float) -> void:
	# Update ability aktif
	if npc_definition != null and npc_definition.ability != null and npc_definition.ability.is_active():
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

func use_ability(world: World) -> bool:
	if not can_use_ability():
		print("[NPC] Ability tidak tersedia untuk ", name)
		return false
	npc_definition.ability.activate(world)
	ability_used.emit(self, npc_definition.ability)
	print("[NPC] ", name, " menggunakan ability: ", npc_definition.ability.ability_name)
	return true

func can_recruit_now() -> bool:
	# check if npc has quest and if quest is completed
	if npc_definition == null or not npc_definition.can_be_recruited:
		return false
	var has_quest := npc_definition != null and npc_definition.quest_definition != null
	if has_quest:
		var quest_status := QuestManager.get_quest_status(npc_definition.quest_definition.id)
		if quest_status != QuestManager.QuestStatus.COMPLETED:
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

func _on_dialogue_finished(status: DialogueManager.DialogueStatus) -> void:
	if not is_recruited and status == DialogueManager.DialogueStatus.DONE and can_recruit_now():
		recruit()

func _on_detected(stalker: StalkerActor) -> void:
	#print_debug("[NPC] detected")
	if is_instance_valid(stalker) and npc_definition.ability.is_active():
		#print_debug("[NPC] stalker detected")
		npc_definition.ability._is_using = true
		npc_definition.ability._target = stalker
		npc_definition.ability._on_use()
