
extends Node2D
class_name WaterCaustics

@export var animation_name: StringName = &"default"

func _ready() -> void:
	for child: Node in get_children():
		if child is AnimatedSprite2D:
			var water_animation: AnimatedSprite2D = child as AnimatedSprite2D
			water_animation.play(animation_name)
