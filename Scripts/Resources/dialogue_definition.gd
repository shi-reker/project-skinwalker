extends Resource
class_name DialogueDefinition

@export var speaker_name: String = ""


@export var dialogue_lines: Array[String]
#[
	#"jerk me off?",
	#"attaboi",
	#":("
#]

class dialogue_part:
	var text: String
	var type: int # 0 normal 1 choice
	
@export var choice_lines: Dictionary[int, Array]
#{
	#0: ["yes", "nah", 1, 2]
#}

@export var end_lines: Dictionary[int, Callable]
#{
	#1: jerk(),
	#10: func{}: pass
#}
