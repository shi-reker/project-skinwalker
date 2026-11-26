extends Node2D
class_name Item

@export var item_def: ItemDefinition

@export var sprite: Sprite2D
@export var interact_c: InteractableComponent

func setup():
	sprite.texture = item_def.texture
