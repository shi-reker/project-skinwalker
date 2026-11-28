extends Node2D
class_name House

var number: int
@export var color: EnvironmentManager.HouseColor
@export var street: Street
@export var order_no: int = -1
@export var interactable: InteractableComponent
@export var is_home: bool = false

func _ready() -> void:
	EnvironmentManager.add_house(self)
	if is_home:
		add_to_group("home")
		QuestManager.quest_status_changed.connect(_on_quest_status_changed)
		setup_home()

func setup_home() -> void:
	if interactable == null:
		push_error("Home house is missing its InteractableComponent.")
		return
	interactable.interact_name = "GO HOME"
	interactable.interact = enter_home
	interactable.is_interactable = is_home_unlocked()

func enter_home() -> void:
	if is_home and not is_home_unlocked():
		return
	Events.home_entered.emit()

func is_home_unlocked() -> bool:
	return not QuestManager.is_pet_quest_active()

func _on_quest_status_changed(_quest_id: QuestManager.QuestId, _status: QuestManager.QuestStatus) -> void:
	if is_home and interactable != null:
		interactable.is_interactable = is_home_unlocked()
