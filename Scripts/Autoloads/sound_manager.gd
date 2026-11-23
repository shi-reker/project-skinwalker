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

var generic_button_hover := "res://Assets/Audio/packs/pack 1/WAV/Retro1.wav"
var play_button := "res://Assets/Audio/packs/pack 1/WAV/Modern15.wav"
var option_button := "res://Assets/Audio/packs/pack 1/WAV/Coffee2.wav"
var quit_button := "res://Assets/Audio/packs/pack 1/WAV/African3.wav"
var generic_button := "res://Assets/Audio/packs/pack 1/WAV/Minimalist11.wav"

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

func play_music(path: String):
	if BGMPlayer.stream == load(path):
		return # lagu sama, jangan restart
	
	BGMPlayer.stop()
	BGMPlayer.stream = load(path)
	BGMPlayer.volume_db = -5
	BGMPlayer.play()

func _play_ui_hover(path: String):
	UIHoverSoundPlayer.stream = load(path)
	UIHoverSoundPlayer.play()

func _play_ui(path: String) -> void:
	UISoundPlayer.stream = load(path)
	UISoundPlayer.play()

func play_button_sfx(): _play_ui(play_button)
func option_button_sfx(): _play_ui(option_button)
func quit_button_sfx(): _play_ui(quit_button)
func general_button_sfx(): _play_ui(generic_button)
