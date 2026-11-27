extends CharacterBody2D
class_name PlayerActor

@onready var movement: MovementComponent = $Components/MovementComponent
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var interact_pop_up: Control = $InteractPopUp
@export var animation: AnimationComponent

signal entered_home
signal interaction_requested

var can_interact: bool = true
var cur_interactables: Array[InteractableComponent] = []
var holding_interact: bool = false
var hold_target: InteractableComponent = null

var player_hints: Array[HintDefinition] = []

var is_disguised: bool = false

func _ready() -> void:
	add_to_group("player")
	state_machine.setup(self)
	interact_pop_up.hide()
	movement.direction_changed.connect(animation._on_movement_direction_changed)


func _physics_process(delta: float) -> void:
	movement.move_with_input(
		Input.get_vector("move_left", "move_right", "move_up", "move_down"),
		delta
	)
	var label: Label = $Label
	label.text = str(global_position)


func set_interaction_available(available: bool, position: Vector2 = global_position) -> void:
	can_interact = available
	interact_pop_up.visible = available
	interact_pop_up.global_position = position


func _unhandled_input(event: InputEvent) -> void:
	if DialogueManager._is_any_dialogue_active:
			return

	if can_interact and cur_interactables:
		var target := cur_interactables[0]

		if event.is_action_pressed("interact"):
			if target.weight == ItemManager.Weight.NONE:
				target.interact.call()
				get_viewport().set_input_as_handled()
			else:
				holding_interact = true
				hold_target = target
				target.begin_hold()

		elif event.is_action_released("interact"):
			if holding_interact and hold_target:
				hold_target.cancel_hold()
			holding_interact = false
			hold_target = null

	# if event.is_action_pressed("ability"):
	# 	_trigger_nearest_ability()
	# 	get_viewport().set_input_as_handled()

# func _trigger_nearest_ability() -> void:
# 	var nearest: NPCActor = null
# 	var nearest_dist := INF

# 	for npc in NpcManager.recruited_npcs:
# 		if npc == null or not is_instance_valid(npc):
# 			continue
# 		print("[Debug] NPC ", npc.name, 
# 			" | has_ability: ", npc.has_ability(), 
# 			" | can_use: ", npc.can_use_ability(),
# 			" | ability_class: ", (npc.npc_definition.ability.get_script().get_global_name() if npc.has_ability() else "none"))
# 		if not npc.can_use_ability():
# 			continue
# 		var d := global_position.distance_to(npc.global_position)
# 		if d < nearest_dist:
# 			nearest_dist = d
# 			nearest = npc

# 	if nearest == null:
# 		print("[Player] Tidak ada ability siap pakai")
# 		return

# 	nearest.use_ability({"player": self})


func _on_detect_area_area_entered(area: Area2D) -> void:
	if area is InteractableComponent:
		set_interaction_available(true, area.global_position)
		cur_interactables.push_back(area)


func _on_detect_area_area_exited(area: Area2D) -> void:
	if area is InteractableComponent:
		cur_interactables.erase(area)
		if cur_interactables.is_empty():
			set_interaction_available(false)
		else:
			set_interaction_available(true, cur_interactables[0].global_position)

func add_hint(hint: HintDefinition) -> void:
	if hint != null and hint not in player_hints:
		player_hints.append(hint)
