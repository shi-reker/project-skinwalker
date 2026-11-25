extends CharacterBody2D
class_name NPCActor

signal recruited(npc: NPCActor)
signal ability_used(npc: NPCActor, ability: NPCAbility)

@export var npc_definition: NPCDefinition

@onready var detection_component: DetectionComponent = $Components/DetectionComponent
@onready var movement_component: MovementComponent = $Components/MovementComponent
@onready var dialogue_component: DialogueComponent = $Components/DialogueComponent
@onready var follow_component: FollowComponent = $Components/FollowComponent
@onready var state_machine: NPCStateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var interactable: InteractableComponent = $InteractableComponent

var is_recruited: bool = false
var has_talked_once: bool = false

func _ready() -> void:
	setup_npc()
	
	interactable.interact_name = "Talk"
	interactable.interact = func(): interact_with_player()
	
	dialogue_component.dialogue_finished.connect(_on_dialogue_finished)
	detection_component.stalker_detected.connect(_on_detected)

	if npc_definition != null and npc_definition.ability != null:
		npc_definition.ability = npc_definition.ability.duplicate(true)
		npc_definition.ability.setup(self)

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

	if npc_definition.texture != null:
		sprite.texture = npc_definition.texture

	if npc_definition.dialogue_definition != null:
		dialogue_component.dialogue_definition = npc_definition.dialogue_definition
		npc_definition.dialogue_definition.recruit_owner.connect(_on_recruit_by_choice)

	if npc_definition.movement_definition != null:
		movement_component.movement_definition = npc_definition.movement_definition

func interact_with_player() -> void:
	if dialogue_component.is_dialogue_active:
		return
	
	if is_recruited:
		dialogue_component.start_dialogue()
		return
	
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
	if npc_definition == null or not npc_definition.can_be_recruited:
		return false

	return true

func recruit() -> void:
	if is_recruited:
		return
	is_recruited = true
	NpcManager._on_npc_recruited(self)

func _on_recruit_by_choice():
	if not is_recruited and can_recruit_now():
		recruit()

func _on_dialogue_finished() -> void:
	if not is_recruited and can_recruit_now():
		recruit()

func _on_detected(stalker: StalkerActor) -> void:
	#print_debug("[NPC] detected")
	if is_instance_valid(stalker) and npc_definition.ability.is_active():
		#print_debug("[NPC] stalker detected")
		npc_definition.ability._is_using = true
		npc_definition.ability._target = stalker
		npc_definition.ability._on_use()
