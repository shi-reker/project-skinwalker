extends Node

enum ItemsId {NONE, KEY}

var item_resource: Dictionary[ItemsId, ItemDefinition] = {
	#ItemsId.NONE: preload(), 
	#ItemsId.KEY: preload()
}

var item_quantities: Dictionary[ItemsId, int] = {}

signal item_accepted(item: ItemDefinition, quantity: int)

func offer_item(item: ItemDefinition, quantity: int = 1) -> bool: 
	if item == null:
		return false
	var item_id: ItemsId = item.id
	var total = int(item_quantities.get(item_id, 0)) + quantity
	item_quantities[item_id] = total
	item_accepted.emit(item, total)
	return true
