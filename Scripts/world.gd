extends Node2D
class_name World

#Music/Sfx related variable
var last_track := -1
@onready var fire_ambiance: AudioStreamPlayer = $FireAmbiance
@onready var vhs_ambiance: AudioStreamPlayer = $VhsAmbiance

#Actor related variable
@export var player: PlayerActor = null
@export var stalker: StalkerActor = null
@export var home: House = null

#Rendering related variable
@export var foreground: TileMapLayer
@export var quests_display: QuestsDisplay= null
@export var debug_label: Label = null
@export var active_debug_label: bool = false
@export var pause_menu: PauseMenu = null

#Gameplay related variable
@export_group("Spawn Layout")
@export var player_spawn: Vector2 = Vector2(400, 300)
@export var stalker_spawn: Vector2 = Vector2(800, 500)
@export var npc_spawn_offset: Vector2 = Vector2(48, 16)

func _ready() -> void:
	#Music related
	play_next_gameplay_music()
	SoundManager.play_ambience("vhs", -7)
	SoundManager.play_ambience("fire", -15)
	SoundManager.play_ambience("night", 1)
	#Debugging
	if active_debug_label == true:
		print_debug(debug_label)
		DebugManager.setup(debug_label)
		DebugManager.add_debug("debug turned on")
		
	if home == null:
		EnvironmentManager.set_home(home)
	else:
		push_error("ADD HOME AND AND SETUP HOME VAR")
	if stalker == null:
		push_error("ADD STALKER AND SETUP STALKER VAR")
	else:
		stalker.add_hint()
	if player == null:
		push_error("ADD PLAYER SCENE AND SETUP PLAYER VAR")
	if quests_display == null:
		push_error("ADD QUESTS DISPLAY SCENE AND SETUP INSIDE INSPECTOR")
	if pause_menu == null:
		push_error("ADD PAUSE MENU SCENE AND SETUP INSIDE INSPECTOR")
	else:
		PauseManager.setup(self, pause_menu)
	# NpcManager.setup(self)
	
	Events.home_entered.connect(_on_player_entered_home)
	Events.player_captured.connect(_on_player_captured)

	# _apply_spawn_layout()
	
	NpcManager.setup(self)
	ItemManager.setup(self)
	QuestManager.setup(quests_display)

func _process(_delta: float) -> void:
	pass 
	#building shader code it works but it does not look good
		#if player == null or foreground == null:
			#return
	#
		#var screen_position = (
			#get_viewport().get_canvas_transform()
			#* player.global_position
			#)
	#
		#var material = foreground.material as ShaderMaterial
	#
		#if material:
			#material.set_shader_parameter(
			#"player_screen_position",
			#screen_position
		#)
		
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


#Background Music
func play_next_gameplay_music() -> void:
	var tracks = SoundManager.gameplay_bgm

	if tracks.is_empty():
		return

	var random_index := randi_range(0, tracks.size() - 1)

	while tracks.size() > 1 and random_index == last_track:
		random_index = randi_range(0, tracks.size() - 1)

	last_track = random_index

	SoundManager.play_gameplay_track(random_index)

	# Tunggu sampai lagu selesai.
	await SoundManager.BGMPlayer.finished

	# Tunggu 30 detik sebelum lagu berikutnya.
	await get_tree().create_timer(30.0).timeout

	# Pastikan scene masih aktif.
	if not is_inside_tree():
		return

	play_next_gameplay_music()
