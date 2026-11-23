extends Node

var BGMPlayer: AudioStreamPlayer
var UISoundPlayer: AudioStreamPlayer2D
var gameplaySoundPlayer: AudioStreamPlayer2D

var play_button := "res://Assets/Audio/pipe.wav"
var option_button
var quit_button
var generic_button

func _ready():
	BGMPlayer = AudioStreamPlayer.new()
	UISoundPlayer = AudioStreamPlayer2D.new()
	gameplaySoundPlayer = AudioStreamPlayer2D.new()
	BGMPlayer.bus = "Music"
	UISoundPlayer.bus = "UI"
	gameplaySoundPlayer.bus = "Gameplay"
	add_child(BGMPlayer)
	add_child(UISoundPlayer)
	add_child(gameplaySoundPlayer)

func play_music(path: String):
	if BGMPlayer.stream == load(path):
		return # lagu sama, jangan restart
	
	BGMPlayer.stop()
	BGMPlayer.stream = load(path)
	BGMPlayer.volume_db = -5
	BGMPlayer.play()

func _play_ui(path: String) -> void:
	UISoundPlayer.stream = load(path)
	UISoundPlayer.play()

func play_button_sfx(): _play_ui(play_button)
func option_button_sfx(): _play_ui(option_button)
func quit_button_sfx(): _play_ui(quit_button)
func general_button_sfx(): _play_ui(generic_button)
