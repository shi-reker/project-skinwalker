extends Area2D
class_name DetectionComponent

var detected_nodes: Array[CharacterBody2D] = []
var current_visible_player: PlayerActor

var target_conditions: Array[Callable] = []
var actor: CharacterBody2D = null
# func(target): return target is yapper

@export var detect_shape: CollisionShape2D # only detect col layer 1

@export var detect_radius: int = 200:
	set(value):
		if value <= 0:
			return
		detect_radius = value
		_update_detect_shape()
	#get():
		#var shape: Shape2D = detect_shape.shape
		#if shape is CircleShape2D:
			#return shape.radius
		#return detect_radius
# Called when the node enters the scene tree for the first time.

signal detected(nodes: Array[CharacterBody2D])
signal player_detected(player: PlayerActor)
signal target_detected(target: Node2D)
signal stalker_detected(stalker: StalkerActor)

func _ready() -> void:
	_update_detect_shape()

func setup(_owner: CharacterBody2D):
	actor = _owner

func _physics_process(_delta: float) -> void:
	if not detected_nodes.is_empty():
		check_blast_radius(detected_nodes)

func _update_detect_shape() -> void:
	if detect_shape == null or detect_shape.shape == null:
		return
	var shape := detect_shape.shape
	if shape is CircleShape2D:
		shape.radius = detect_radius

func check_blast_radius(targets: Array[CharacterBody2D]) -> void:
	var space_state = get_world_2d().direct_space_state
	var seen: Array[CharacterBody2D] = []
	var visible_player: PlayerActor = null
	
	for target in targets:
		if not is_instance_valid(target):
			continue
		var query = PhysicsRayQueryParameters2D.create(global_position, target.global_position)
		var excluded_rids: Array[RID] = [get_rid()]
		var actor_body := actor as CollisionObject2D
		if actor_body != null:
			excluded_rids.append(actor_body.get_rid())
		query.exclude = excluded_rids
		
		var result = space_state.intersect_ray(query)
		
		if result and result.collider == target:
			seen.append(target)

			if target is PlayerActor and visible_player == null:
				visible_player = target
			if target_conditions.is_empty():
				continue
			for c in target_conditions:
				if c.call(target):
					target_detected.emit(target)
	if current_visible_player != null and not is_instance_valid(current_visible_player):
		current_visible_player = null
	if visible_player != current_visible_player:
		current_visible_player = visible_player
		player_detected.emit(visible_player)

	detected.emit(seen)

func _on_body_entered(body: Node2D) -> void:
	var character_body := body as CharacterBody2D
	if character_body != null and not detected_nodes.has(character_body):
		detected_nodes.append(character_body)
	for node in detected_nodes:
		if node is StalkerActor:
			stalker_detected.emit(node)
			break

func _on_body_exited(body: Node2D) -> void:
	detected_nodes.erase(body)
