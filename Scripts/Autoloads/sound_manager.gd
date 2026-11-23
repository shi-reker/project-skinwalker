extends Node

var bgm_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

var main_menu_press := "res://Assets/Audio/pipe.wav"

func _ready():
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "Music"
	add_child(bgm_player)
		

func play_music(path: String):
	if bgm_player.stream == load(path):
		return # lagu sama, jangan restart
	
	bgm_player.stop()
	bgm_player.stream = load(path)
	bgm_player.volume_db = -5
	bgm_player.play()

func play_sfx():
	sfx_player.stream = load("res://Assets/Audio/pipe.wav")	
	sfx_player.play()

# AudioManager.play_sfx(Audiomanager.
