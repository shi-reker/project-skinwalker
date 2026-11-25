extends Node2D
class_name World

@export var player: PlayerActor
@export var stalker: StalkerActor
@export var home: House

@export var debug_label: Label
@export var active_debug_label: bool = false

@export_group("Spawn Layout")
@export var player_spawn: Vector2 = Vector2(400, 300)
@export var stalker_spawn: Vector2 = Vector2(800, 500)
@export var npc_spawn_offset: Vector2 = Vector2(48, 16)

func _ready() -> void:
	if home != null:
		EnvironmentManager.set_home(home)
	if stalker != null:
		stalker.add_hint()
	# NpcManager.setup(self)
	Events.home_entered.connect(_on_player_entered_home)
	Events.player_captured.connect(_on_player_captured)

	#_apply_spawn_layout()

	NpcManager.setup(self)
	
	if active_debug_label:
		DebugManager.setup(debug_label)
		DebugManager.add_debug("debug turned on")

func _apply_spawn_layout() -> void:
	if player:
		player.global_position = player_spawn
	if stalker:
		stalker.global_position = stalker_spawn

	var npcs := get_tree().get_nodes_in_group("npc")
	if npcs.size() > 0 and player:
		(npcs[0] as Node2D).global_position = player_spawn + npc_spawn_offset



func on_player_captured() -> void:
	print("[World] Player tertangkap — reset posisi")
	if player:
		player.global_position = player_spawn
	if stalker:
		stalker.global_position = stalker_spawn

func _on_player_entered_home():
	print("gone home!")
	if stalker.is_player_detected:
		stalker.detected_player_entered_home()

func _on_player_captured():
	print_debug("YOU LOSEEEEE")
