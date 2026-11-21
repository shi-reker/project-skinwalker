extends Area2D
class_name CompanionBehaviorComponent

@export var behavior_definition: CompanionBehaviorDefinition
@onready var trigger_shape: CollisionShape2D = $CollisionShape2D

var is_recruited: bool = false

func _ready() -> void:
	if behavior_definition == null:
		push_error("Companion behavior component requires a behavior definition.")
		return
	var circle := trigger_shape.shape as CircleShape2D
	if circle != null:
		circle.radius = behavior_definition.trigger_radius
	monitoring = false

func set_recruited(recruited: bool) -> void:
	is_recruited = recruited
	if is_inside_tree():
		set_deferred("monitoring", recruited)
	else:
		monitoring = recruited

func _physics_process(_delta: float) -> void:
	if not is_recruited or behavior_definition == null:
		return
	if behavior_definition.ability != CompanionBehaviorDefinition.Ability.STUN_NEARBY_STALKER:
		return
	for body: Node2D in get_overlapping_bodies():
		if body is StalkerActor:
			body.apply_stun(behavior_definition.stun_duration)
