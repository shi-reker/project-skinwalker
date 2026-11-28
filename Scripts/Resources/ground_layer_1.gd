
extends TileMapLayer

@export var vehicles: TileMapLayer

# Ground cells that should be blocked by building bases.
@export var blocked_cells: Array[Vector2i] = []

var blocked: Dictionary = {}

func _ready() -> void:
	call_deferred("rebuild_navigation")

func rebuild_navigation() -> void:
	blocked.clear()

	for cell in blocked_cells:
		blocked[cell] = true

	if vehicles != null:
		for cell in vehicles.get_used_cells():
			var world_pos := vehicles.to_global(vehicles.map_to_local(cell))
			var ground_cell := local_to_map(to_local(world_pos))
			blocked[ground_cell] = true

	notify_runtime_tile_data_update()

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return blocked.has(coords)

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	tile_data.set_navigation_polygon(0, null)
