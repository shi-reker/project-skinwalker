extends Control
class_name  QuestsDisplay

@export var quests_container: VBoxContainer
@export var quest_scene: PackedScene
var quest_node: Dictionary[QuestManager.QuestId, ProgressDisplay] = {}

func setup():
	reset()
	
func add_quest(quest_def: QuestDefinition):
	if quest_node.has(quest_def.id):
		return
	var display := quest_scene.instantiate() as ProgressDisplay
	quests_container.add_child(display)
	display.quest_text = quest_def.title
	quest_node[quest_def.id] = display

func update_quest(quest: QuestDefinition, progress: int):
	if not quest_node.has(quest.id):
		add_quest(quest)
	quest_node[quest.id].progress_text = "%d/%d" % [progress, quest.required_count]

func reset():
	for child in quests_container.get_children():
		child.queue_free()
	quest_node.clear()
