extends Node
class_name MovementComponent

@export var movement_definition: MovementDefinition
@export var actor: CharacterBody2D
var input_direction: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var target_velocity: Vector2 = Vector2.ZERO

func move_to(destination: Vector2) -> void:
	pass

func stop_movement() -> void:
	pass
