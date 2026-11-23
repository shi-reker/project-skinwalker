extends TileMapLayer

@export var buildings: TileMapLayer
@export var vehicles: TileMapLayer

func _blocked(coords: Vector2i) -> bool:
	return buildings.get_cell_source_id(coords) in [2, 3] \
		or vehicles.get_cell_source_id(coords) == 2

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return _blocked(coords)

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if _blocked(coords):
		tile_data.set_navigation_polygon(0, null)  # layer 0, not the source ID
