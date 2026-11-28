extends CharacterBody2D
class_name Pet

@export var animation: AnimationComponent
@export var movement: MovementComponent
@export var interactable: InteractableComponent
@export var follow_component: FollowComponent
@export var movement_def: MovementDefinition

var has_fled_once: bool = false
var is_fleeing_to_street: bool = false
var flee_destination: Vector2

const PET_QUEST: QuestDefinition = preload("res://Resources/Quests/find_pet.tres")

func _ready() -> void:
	if interactable == null:
		push_error("Pet is missing its InteractableComponent reference.")
		return
	if movement == null:
		push_error("Pet is missing its MovementComponent reference.")
		return
	if animation == null:
		push_error("Pet is missing its AnimationComponent reference.")
		return
	if follow_component == null:
		push_error("Pet is missing its FollowComponent reference.")
		return

	interactable.setup(self, "Pick up", ItemManager.Weight.HEAVY, _on_pickup_attempted)
	movement.direction_changed.connect(animation._on_movement_direction_changed.bind(false, true))
	animation.play()
	if QuestManager.is_pet_quest_completed():
		interactable.is_interactable = false
		call_deferred("_start_following_player")
	else:
		QuestManager.offer_quest(PET_QUEST)
	movement.setup(self, movement_def)

func _physics_process(delta: float) -> void:
	if not is_fleeing_to_street:
		return

	movement.move_to(flee_destination, delta)
	if movement.is_target_reached():
		is_fleeing_to_street = false
		interactable.is_interactable = true

func _on_pickup_attempted() -> void:
	if not has_fled_once:
		_move_to_another_street()
		return

	if not QuestManager.record_pet_pickup():
		print_debug("FAIL!")
		return
	print_debug("GOTCHA")

	interactable.is_interactable = false
	#interactable.set_deferred("monitoring", false)
	_start_following_player()

func _move_to_another_street() -> void:
	var destinations: Array[Street] = []
	for street in EnvironmentManager.street_nodes:
		if is_instance_valid(street) and street.global_position.distance_squared_to(global_position) > 1.0:
			destinations.append(street)

	if destinations.is_empty():
		push_error("Pet cannot flee because no different street location is available.")
		return

	var destination: Street = destinations.pick_random()
	flee_destination = destination.global_position
	is_fleeing_to_street = true
	has_fled_once = true
	interactable.is_interactable = false

func _start_following_player() -> void:
	print_debug("SEARCH PLAYER")
	var player :PlayerActor = NpcManager.world.player
	if player == null:
		print_debug("FOUND NONE")
		push_error("Pet cannot follow because no player is present in the scene.")
		return
	else:
		print_debug("found player")
		follow_component.start_following(self, movement, player)
