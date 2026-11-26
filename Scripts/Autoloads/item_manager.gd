extends Node

enum ItemsId {NONE, KEY, HAIR_PRODUCT}
enum Weight {NONE, LIGHT, MEDIUM, HEAVY}

var item_resource: Dictionary[ItemsId, ItemDefinition] = {
	#ItemsId.NONE: preload(), 
	#ItemsId.KEY: preload()
}

var item_quantities: Dictionary[ItemsId, int] = {}

signal item_accepted(item: ItemDefinition, quantity: int)

var world: World

func setup(_world: World):
	world = _world
func offer_item(item: Item, quantity: int = 1) -> bool: 
	if item == null:
		return false
	var item_id: ItemsId = item.id
	var total = int(item_quantities.get(item_id, 0)) + quantity
	item_quantities[item_id] = total
	item_accepted.emit(item, total)
	return true
