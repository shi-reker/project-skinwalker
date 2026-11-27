extends Node

var BGMPlayer: AudioStreamPlayer
var UISoundPlayer: AudioStreamPlayer2D
var UIHoverSoundPlayer: AudioStreamPlayer2D
var gameplaySoundPlayer: AudioStreamPlayer2D

#Main Menu
var menuBGM := "res://Assets/Audio/Music/lux-aeterna-liminal-loop-617237.ogg"
var tv_on_sfx := "res://Assets/Audio/Sound Effects/TV on.wav"
var tv_static_on_sfx := "res://Assets/Audio/Sound Effects/tv static on.wav"
var tv_off_sfx := "res://Assets/Audio/Sound Effects/TV off.wav"
var lights_on_sfx := "res://Assets/Audio/Sound Effects/lights on.wav"
var lights_off_sfx := "res://Assets/Audio/Sound Effects/lights off.wav"
var door_creak := "res://Assets/Audio/Sound Effects/Door creak.wav"
var book_open := "res://Assets/Audio/Sound Effects/book_open.wav"

#UI
var generic_button_hover := "res://Assets/Audio/packs/pack 1/WAV/Retro1.wav"
var play_button := "res://Assets/Audio/packs/pack 1/WAV/Modern15.wav"
var option_button := "res://Assets/Audio/packs/pack 1/WAV/Coffee2.wav"
var quit_button := "res://Assets/Audio/packs/pack 1/WAV/African3.wav"
var generic_button := "res://Assets/Audio/packs/pack 1/WAV/Minimalist11.wav"

# Gameplay BGM
var gameplay_bgm := [
	"res://Assets/Audio/Music/Broken [Soundtrack] 3N.wav",
	"res://Assets/Audio/Music/Coffee [Soundtrack] 3N.wav",
	"res://Assets/Audio/Music/psylokid - alone in a room.ogg",
	"res://Assets/Audio/Music/lux-aeterna-liminal-loop-617237.ogg"
]
var last_played_track := -1

#Ambience
var ambience_players: Dictionary = {}
var ambience_sounds := {
	"vhs": "res://Assets/Audio/Ambience/609360__florstristi__vhs_vcr-hum-crunchy.ogg",
	"fire": "res://Assets/Audio/Ambience/182368__kingsrow__fire-crackling-02.ogg",
}

func _ready():
	BGMPlayer = AudioStreamPlayer.new()
	UISoundPlayer = AudioStreamPlayer2D.new()
	gameplaySoundPlayer = AudioStreamPlayer2D.new()
	UIHoverSoundPlayer = AudioStreamPlayer2D.new()
	BGMPlayer.bus = "Music"
	UISoundPlayer.bus = "UI"
	UIHoverSoundPlayer.bus = "UI"
	gameplaySoundPlayer.bus = "Gameplay"
	add_child(BGMPlayer)
	add_child(UISoundPlayer)
	add_child(UIHoverSoundPlayer)
	add_child(gameplaySoundPlayer)
	
func play_music(path: String, volume: float = 0.0):
	#if BGMPlayer.stream == load(path):
		#return # lagu sama, jangan restart
	
	BGMPlayer.stop()
	BGMPlayer.stream = load(path)
	BGMPlayer.volume_db = volume
	BGMPlayer.play()
	
func play_menu_music():
	play_music(menuBGM, -5)
	
func play_gameplay_track(index: int) -> void:
	if index < 0 or index >= gameplay_bgm.size():
		return

	play_music(gameplay_bgm[index], -20)

func play_ambience(id: String, volume: float = 0.0) -> void:
	if not ambience_sounds.has(id):
		push_warning("Ambience not found: " + id)
		return

	if ambience_players.has(id):
		return

	var player := AudioStreamPlayer.new()
	player.bus = "Ambience"
	player.stream = load(ambience_sounds[id])
	player.volume_db = volume

	if player.stream is AudioStreamWAV:
		player.stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	elif player.stream is AudioStreamOggVorbis:
		player.stream.loop = true

	add_child(player)
	ambience_players[id] = player
	player.play()
func _play_ui_hover(path: String, volume: float = 0.0):
	UIHoverSoundPlayer.stream = load(path)
	UIHoverSoundPlayer.volume_db = volume
	UIHoverSoundPlayer.play()

func _play_ui(path: String, volume: float = 0.0) -> void:
	UISoundPlayer.stream = load(path)
	UISoundPlayer.volume_db = volume
	UISoundPlayer.play()

func play_button_sfx(): _play_ui(play_button, 7)
func option_button_sfx(): _play_ui(option_button, 7)
func quit_button_sfx(): _play_ui(quit_button, 7)
func general_button_sfx(): _play_ui(generic_button, 10)
func option_menu_open_sfx(): _play_ui(book_open)
