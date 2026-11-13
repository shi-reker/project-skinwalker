extends Resource
class_name HintDefinition

enum HintCategory {
	HOUSE_COLOR,
	GATE,
	STREET,
}

@export var category: HintCategory = HintCategory.STREET
@export var hint_value: String = ""
@export var confidence: float = 0.0
@export var is_active: bool = true
