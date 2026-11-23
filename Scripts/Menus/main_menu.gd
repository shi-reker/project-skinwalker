extends Control

@onready var tv: TextureButton = $SubViewportContainer/SubViewport/Buttons/Play
@onready var bookshelf: TextureButton = $SubViewportContainer/SubViewport/Buttons/Options
@onready var door: TextureButton = $SubViewportContainer/SubViewport/Buttons/Exit

@onready var music_delay: Timer = $MusicDelay
@onready var fire_ambiance: AudioStreamPlayer = $FireAmbiance
@onready var vhs_ambiance: AudioStreamPlayer = $VhsAmbiance

var settings_scene = preload("res://Scenes/Components/Pause Component/options.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.BGMPlayer.finished.connect(_on_music_finished)
	music_delay.timeout.connect(_on_music_delay_timeout)

	SoundManager.play_music(SoundManager.menuBGM)
	fire_ambiance.play()
	vhs_ambiance.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_music_finished() -> void:
	music_delay.start()

func _on_music_delay_timeout() -> void:
	SoundManager.play_music(SoundManager.menuBGM)

func _on_play_pressed() -> void:
	SoundManager.play_button_sfx()
	await SoundManager.UISoundPlayer.finished
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	
func _on_options_pressed() -> void:
	SoundManager.option_button_sfx()
	await SoundManager.UISoundPlayer.finished
	var settings = settings_scene.instantiate()
	add_child(settings)
	var shader_index = get_node("ShaderCanvas").get_index()
	move_child(settings, shader_index)
	settings.closed.connect(_on_settings_closed)
	
func _on_exit_pressed() -> void:
	SoundManager.quit_button_sfx()
	await SoundManager.UISoundPlayer.finished
	get_tree().quit()
	
func _on_play_mouse_entered() -> void:
	SoundManager._play_ui_hover(SoundManager.tv_on_sfx)
	SoundManager._play_ui_hover(SoundManager.tv_static_on_sfx)

func _on_play_mouse_exited() -> void:
	SoundManager._play_ui_hover(SoundManager.tv_off_sfx)

func _on_options_mouse_entered() -> void:
	SoundManager._play_ui_hover(SoundManager.lights_on_sfx)

func _on_options_mouse_exited() -> void:
	SoundManager._play_ui_hover(SoundManager.lights_off_sfx)

func _on_exit_mouse_entered() -> void:
	SoundManager._play_ui_hover(SoundManager.door_creak)

func _on_settings_closed() -> void:
	print("Settings closed")
