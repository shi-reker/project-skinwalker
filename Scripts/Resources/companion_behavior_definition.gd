extends Resource
class_name CompanionBehaviorDefinition

enum Ability {
	NONE,
	STUN_NEARBY_STALKER,
}

@export var ability: Ability = Ability.NONE
@export_range(0.0, 1000.0, 1.0) var trigger_radius: float = 64.0
@export_range(0.0, 60.0, 0.1) var stun_duration: float = 1.0
