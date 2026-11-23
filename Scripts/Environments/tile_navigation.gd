extends TileMapLayer

@export var buildings: TileMapLayer
@export var vehicles: TileMapLayer

var blocked := {}

func _ready() -> void:
	call_deferred("rebuild_blocked")

func rebuild_blocked() -> void:
	blocked.clear()
	for layer in [buildings, vehicles]:
		if layer == null:
			continue
		for cell in layer.get_used_cells():
			var data = layer.get_cell_tile_data(cell)
			var source = layer.tile_set.get_source(layer.get_cell_source_id(cell))
			if data == null or not (source is TileSetAtlasSource):
				continue

			var atlas_size: Vector2i = source.get_tile_size_in_atlas(layer.get_cell_atlas_coords(cell))
			var px_size := Vector2(atlas_size * layer.tile_set.tile_size)

			# Where the art is drawn: centered on the cell, shifted by texture_origin
			var center = layer.map_to_local(cell) - Vector2(data.texture_origin)
			var top_left = center - px_size / 2.0
			var bottom_right = top_left + px_size

			# Inset 1px so edges don't spill into neighbouring cells
			var from := local_to_map(top_left + Vector2.ONE)
			var to := local_to_map(bottom_right - Vector2.ONE)
			for x in range(from.x, to.x + 1):
				for y in range(from.y, to.y + 1):
					blocked[Vector2i(x, y)] = true
	notify_runtime_tile_data_update()

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return blocked.has(coords)

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	tile_data.set_navigation_polygon(0, null)
