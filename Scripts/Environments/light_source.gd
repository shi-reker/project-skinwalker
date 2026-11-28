
@tool
extends Node2D
class_name LightSource2D

@export_group("Light Settings")

@export var light_color: Color = Color("#e29d00"):
	set(value):
		light_color = value
		_update_light()

@export_range(0.0, 10.0, 0.05) var light_energy: float = 1.28:
	set(value):
		light_energy = value
		_update_light()

@export_range(0.1, 5.0, 0.05) var light_scale: float = 1.76:
	set(value):
		light_scale = value
		_update_light()


func _ready() -> void:
	_update_light()


func _update_light() -> void:
	var point_light: PointLight2D = get_node_or_null("PointLight2D") as PointLight2D

	if point_light == null:
		return

	point_light.color = light_color
	point_light.energy = light_energy
	point_light.texture_scale = light_scale
