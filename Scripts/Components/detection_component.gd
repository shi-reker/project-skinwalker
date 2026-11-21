@tool
extends Area2D
class_name DetectionComponent

var detected_nodes: Array[CharacterBody2D] = []

@export var detect_shape: CollisionShape2D # only detect col layer 1

@export var detect_radius: int = 200:
	set(value):
		if value <= 0:
			return
		print_debug(value)
		detect_radius = value
		var shape: Shape2D = detect_shape.shape
		print_debug("got shape")
		if shape is CircleShape2D:
			shape.radius = value
			print_debug(shape.radius)
# Called when the node enters the scene tree for the first time.

signal detected(nodes: Array[CharacterBody2D])

func _physics_process(_delta: float) -> void:
	check_blast_radius(detected_nodes)

func check_blast_radius(targets: Array[CharacterBody2D]) -> void:
	var space_state = get_world_2d().direct_space_state
	
	var seen: Array[CharacterBody2D] = []
	
	for target in targets:
		if not is_instance_valid(target):
			continue
		var query = PhysicsRayQueryParameters2D.create(global_position, target.global_position)
		var excluded_rids: Array[RID] = [get_rid()]
		var actor_body := get_parent().get_parent() as CollisionObject2D
		if actor_body != null:
			excluded_rids.append(actor_body.get_rid())
		query.exclude = excluded_rids
		
		var result = space_state.intersect_ray(query)
		
		if result and result.collider == target:
			seen.append(target)

	detected.emit(seen)
func _on_body_entered(body: Node2D) -> void:
	var character_body := body as CharacterBody2D
	if character_body != null and not detected_nodes.has(character_body):
		detected_nodes.append(character_body)

func _on_body_exited(body: Node2D) -> void:
	detected_nodes.erase(body)
