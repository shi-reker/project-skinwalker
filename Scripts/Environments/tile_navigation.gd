extends TileMapLayer

@export var buildings: TileMapLayer
@export var vehicles: TileMapLayer

func _blocked(coords: Vector2i) -> bool:
	return buildings.get_cell_source_id(coords) in [2, 3] \
		or vehicles.get_cell_source_id(coords) == 2

func _ready() -> void:
	if buildings == null:
		push_error("TileNavigation requires a buildings TileMapLayer.")
	if vehicles == null:
		push_error("TileNavigation requires a vehicles TileMapLayer.")
	notify_runtime_tile_data_update()

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return _blocked(coords)

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if _blocked(coords):
		for layer_id in range(tile_set.get_navigation_layers_count()):
			tile_data.set_navigation_polygon(layer_id, null)
