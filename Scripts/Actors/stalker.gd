extends CharacterBody2D
class_name StalkerActor

@export var movement_component: MovementComponent
@onready var state_machine: StalkerStateMachine = $StateMachine
@export var stalker_definition: StalkerDefinition = null
@export var known_hints: Array[HintDefinition] = []
#@export var deployed_detection_systems: Array[DetectionSystem] = []
@export var animation: AnimationComponent = null
@export var sprite:Sprite2D
@export var detection_component: DetectionComponent
@export var target:PlayerActor
var hints: EnvironmentManager.HomeHints = EnvironmentManager.HomeHints.new()
#@export var navAgent:NavigationAgent2D
var isImmobilized:bool = false
var moveSpeedCache:float = 0
var distToTarget:float = 0
var is_player_detected: bool = false

func _ready() -> void:
	add_to_group("stalker")
	if stalker_definition != null:
		var frames: SpriteFrames = stalker_definition.frames
		if frames != null:
			animation.sprite_frames = frames
			movement_component.direction_changed.connect(animation._on_movement_direction_changed)
		
		elif stalker_definition.texture != null:
			sprite.texture = stalker_definition.texture
		else:
			push_error("add visuals to npc def ", stalker_definition.display_name)
	sprite.scale = Vector2(0.1, 0.1)
	movement_component.setup(self)
	state_machine.setup(self)
	detection_component.setup(self)
	detection_component.player_detected.connect(state_machine._on_detected)
	print_debug("[Owner of stalker's detect comp] = ",detection_component.owner.name)
	movement_component.rangeBorders = 160
	movement_component.at_range.connect(state_machine.handle_dist_to_player)
	
	state_machine.setup(self)

func _physics_process(delta: float) -> void:
	state_machine.update_current_state(delta)

func detected_player_entered_home():
	print("i see you :)")

func add_hint() -> void:
	hints = EnvironmentManager.HomeHints.new()
	hints.is_color_guessed = true
	#for hint: HintDefinition in stalker_definition.initial_hints:
		#if hint == null or not hint.is_active:
			#continue
		#match hint.category:
			#HintDefinition.HintCategory.HOUSE_COLOR:
				#hints.is_color_guessed = true
			#HintDefinition.HintCategory.STREET:
				#hints.is_street_guessed = true

	if is_instance_valid(EnvironmentManager.home_node):
		hints = EnvironmentManager.reveal_hints(hints)

func _on_immobilized(_state:bool):
	if _state:
		isImmobilized = true
		moveSpeedCache = movement_component.movement_definition.walk_speed
		movement_component.movement_definition.walk_speed = 0
	else:
		isImmobilized = false
		movement_component.movement_definition.walk_speed = moveSpeedCache

func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	pass # Replace with function body.

func _on_detection_range_entered(body: Node2D) -> void:
	if body is PlayerActor:
		state_machine.change_state(state_machine.stateTable[state_machine.State.PURSUING])

func _on_detection_range_exited(body: Node2D) -> void:
	if body is PlayerActor:
		state_machine.change_state(state_machine.stateTable[state_machine.State.SEARCHING])
