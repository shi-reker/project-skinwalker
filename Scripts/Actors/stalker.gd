extends CharacterBody2D
class_name StalkerActor

@export var movement_component: MovementComponent
@onready var state_machine: StalkerStateMachine = $StateMachine
@export var stalker_definition: StalkerDefinition
@export var sprite:Sprite2D
@export var detection_component: DetectionComponent
@export var target:PlayerActor
var hints: EnvironmentManager.HomeHints = EnvironmentManager.HomeHints.new()
#@export var navAgent:NavigationAgent2D

var distToTarget:float = 0
var is_player_detected: bool = false

func _ready() -> void:
	sprite.texture = stalker_definition.texture
	sprite.scale = Vector2(0.1, 0.1)
	movement_component.actor = self
	state_machine.setup(self)
	detection_component.player_detected.connect(state_machine._on_detected)

func _physics_process(delta: float) -> void:
	state_machine.update_current_state(delta)
	#if target == null or not is_instance_valid(target):
		#return
	#distToTarget = global_position.distance_to(target.global_position)
	#if distToTarget < 60 and state_machine.current_state != state_machine.captureState:
		#state_machine.change_state(state_machine.captureState)

func detected_player_entered_home():
	print("i see you :)")

func add_hint() -> void:
	hints = EnvironmentManager.HomeHints.new()
	hints.is_color_guessed = true
	for hint: HintDefinition in stalker_definition.initial_hints:
		if hint == null or not hint.is_active:
			continue
		match hint.category:
			HintDefinition.HintCategory.HOUSE_COLOR:
				hints.is_color_guessed = true
			HintDefinition.HintCategory.STREET:
				hints.is_street_guessed = true

	if is_instance_valid(EnvironmentManager.home_node):
		hints = EnvironmentManager.reveal_hints(hints)

func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	pass # Replace with function body.
