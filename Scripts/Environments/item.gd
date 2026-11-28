extends Node2D
class_name Item

@export var item_def: ItemDefinition

@export var sprite: Sprite2D
@export var interact_c: InteractableComponent

func setup():
	position = item_def.position
	sprite.texture = item_def.texture
	ItemManager.item_quantities[item_def.id] = 0
	interact_c.setup(self, "collect", item_def.weight, _collect)

func _collect() -> void:
	if ItemManager.offer_item(self):
		queue_free()
