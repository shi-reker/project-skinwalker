
extends NavigationRegion2D
class_name NavigationGenerator

const OBSTACLE_GROUP: StringName = &"navigation_obstacles"

@export_group("Obstacle Settings")
@export var obstacle_layers: Array[TileMapLayer] = []

# Sesuaikan dengan Physics Layer collision bangunan dan objek.
@export_flags_2d_physics var obstacle_collision_mask: int = 2

@export_group("Navigation Settings")
@export_range(0.0, 32.0, 0.5) var agent_radius: float = 0.0


func _ready() -> void:
	call_deferred("generate_navigation")


func generate_navigation() -> void:
	if navigation_polygon == null:
		push_error("[NavigationGenerator] NavigationPolygon resource is missing.")
		return

	# Duplikasi resource agar resource asli tidak ikut berubah.
	navigation_polygon = navigation_polygon.duplicate(true)

	# Daftarkan semua TileMapLayer obstacle ke group.
	for layer in obstacle_layers:
		if not is_instance_valid(layer):
			push_error("[NavigationGenerator] Invalid obstacle layer.")
			continue

		if not layer.is_in_group(OBSTACLE_GROUP):
			layer.add_to_group(OBSTACLE_GROUP)

	# Baca geometry dari static colliders.
	navigation_polygon.parsed_geometry_type = \
		NavigationPolygon.PARSED_GEOMETRY_STATIC_COLLIDERS

	# Cari sumber geometry melalui group.
	navigation_polygon.source_geometry_mode = \
		NavigationPolygon.SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN

	navigation_polygon.source_geometry_group_name = OBSTACLE_GROUP

	# Physics layer yang akan dibaca.
	navigation_polygon.parsed_collision_mask = obstacle_collision_mask

	# Radius stalker.
	navigation_polygon.agent_radius = agent_radius

	print("[NavigationGenerator] Starting navigation bake...")

	# Bake navigation.
	bake_navigation_polygon(false)

	print("[NavigationGenerator] Navigation bake finished.")
