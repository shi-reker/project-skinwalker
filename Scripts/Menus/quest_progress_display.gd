extends Control
class_name  ProgressDisplay

@export var quest_text: String:
	set(value):
		quest_text = value
		quest_details.text = value

@export var progress_text: String:
	set(value):
		progress_text = value
		quest_progress.text = value

@export var quest_details: Label
@export var quest_progress: Label
