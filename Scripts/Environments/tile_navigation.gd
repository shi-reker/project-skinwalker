extends TileMapLayer

@export var buildings:TileMapLayer
@export var vehicles:TileMapLayer

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	if coords in buildings.get_used_cells_by_id(2) or coords in buildings.get_used_cells_by_id(3):
		return true
	if coords in vehicles.get_used_cells_by_id(2):
		return true
	return false

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if coords in buildings.get_used_cells_by_id(2) or coords in vehicles.get_used_cells_by_id(2):
		tile_data.set_navigation_polygon(2, null)
	elif coords in buildings.get_used_cells_by_id(3):
		tile_data.set_navigation_polygon(3, null)
	
