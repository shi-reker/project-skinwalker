extends Resource
class_name DialogueDefinition

@export var speaker_name: String = ""


@export var dialogue_lines: Array[String]
#[
	#"jerk me off?",
	#"attaboi",
	#":("
#]

@export var choice_lines: Dictionary[int, Array]
#{
	#0: ["yes", "nah", 1, 2]
#}

@export var end_lines: Dictionary[int, Callable]
#{
	#1: jerk(),
	#10: func{}: pass
#}
