extends Control

@onready var tv: TextureButton = $SubViewportContainer/SubViewport/Buttons/Play
@onready var bookshelf: TextureButton = $SubViewportContainer/SubViewport/Buttons/Options
@onready var door: TextureButton = $SubViewportContainer/SubViewport/Buttons/Exit

@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var music_delay: Timer = $MusicDelay
@onready var fire_ambiance: AudioStreamPlayer = $FireAmbiance
@onready var vhs_ambiance: AudioStreamPlayer = $VhsAmbiance
@onready var tv_on_sfx: AudioStreamPlayer = $TVOnSfx
@onready var tv_static_on_sfx: AudioStreamPlayer = $TVStaticOnSfx
@onready var tv_off_sfx: AudioStreamPlayer = $TVOffSfx
@onready var lights_on_sfx: AudioStreamPlayer = $LightOnSfx
@onready var lights_off_sfx: AudioStreamPlayer = $LightsOffSfx
@onready var door_creak: AudioStreamPlayer = $DoorCreakSfx

var settings_scene = preload("res://Scenes/Components/Pause Component/options.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_music.finished.connect(_on_music_finished)
	music_delay.timeout.connect(_on_music_delay_timeout)

	background_music.play()
	fire_ambiance.play()
	vhs_ambiance.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_music_finished() -> void:
	music_delay.start()

func _on_music_delay_timeout() -> void:
	background_music.play()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	#SoundManager.play_button_press()
	
func _on_options_pressed() -> void:
	var settings = settings_scene.instantiate()
	add_child(settings)
	var shader_index = get_node("ShaderCanvas").get_index()
	move_child(settings, shader_index)
	settings.closed.connect(_on_settings_closed)
	
func _on_exit_pressed() -> void:
	pass # Replace with function body.
	
func _on_play_mouse_entered() -> void:
	tv_on_sfx.play()
	tv_static_on_sfx.play()
	
func _on_play_mouse_exited() -> void:
	tv_off_sfx.play()
	
func _on_options_mouse_entered() -> void:
	lights_on_sfx.play()
	
func _on_options_mouse_exited() -> void:
	lights_off_sfx.play()
	
func _on_exit_mouse_entered() -> void:
	door_creak.play()
func _on_settings_closed() -> void:
	print("Settings closed")
