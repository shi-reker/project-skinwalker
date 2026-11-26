extends Node

enum ItemsId {NONE, KEY, HAIR_PRODUCT}
enum Weight {NONE, LIGHT, MEDIUM, HEAVY}

var item_resource: Dictionary[ItemsId, ItemDefinition] = {
	#ItemsId.NONE: preload(), 
	#ItemsId.KEY: preload()
	ItemsId.HAIR_PRODUCT: preload("res://Resources/Quests/hair_product.tres")
}

var item_quantities: Dictionary[ItemsId, int] = {}
var item_scene: PackedScene = preload("res://Scenes/Components/quest_item.tscn")

signal item_accepted(item: ItemDefinition, quantity: int)

var world: World

func setup(_world: World):
	world = _world

func spawn_item(item_id: ItemsId, quantity: int = 1):
	var item_def: ItemDefinition = item_resource[item_id]
	var item_node: Item = item_scene.instantiate()
	var position: Vector2 = item_def.position
	# add position
	world.add_child(item_node)
	item_node.global_position = position
	item_node.item_def = item_def
	item_node.setup()

func offer_item(item: Item, quantity: int = 1) -> bool: 
	if item == null:
		return false
	var item_id: ItemsId = item.item_def.id
	var total = int(item_quantities.get(item_id, 0)) + quantity
	item_quantities[item_id] = total
	item_accepted.emit(item.item_def, total)
	print_debug("got new item!")
	QuestManager._on_item_accepted(item.item_def, total)
	return true

func pickup_item(item: Item):
	item.pickup()
