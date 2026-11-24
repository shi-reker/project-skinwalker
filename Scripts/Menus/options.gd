
extends Control

signal closed

@onready var master_slider: HSlider = $SettingsContent/MasterSlider
@onready var music_slider: HSlider = $SettingsContent/MusicSlider
@onready var sfx_slider: HSlider = $SettingsContent/SFXSlider
@onready var ui_slider: HSlider = $SettingsContent/UISlider

@onready var display_mode: OptionButton = $SettingsContent/DisplayModeDropdown

func _ready() -> void:
	SoundManager.option_menu_open_sfx()
	display_mode.item_selected.connect(_on_display_mode_selected)

	update_display_mode()	
	# Initialize sliders from current audio bus settings
	master_slider.value = get_bus_slider_value("Master")
	music_slider.value = get_bus_slider_value("Music")
	sfx_slider.value = get_bus_slider_value("Gameplay")
	ui_slider.value = get_bus_slider_value("UI")

	# Connect signals
	master_slider.value_changed.connect(_on_master_changed)
	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	ui_slider.value_changed.connect(_on_ui_changed)


# Get current bus volume as percentage
func get_bus_slider_value(bus_name: String) -> float:
	var bus = AudioServer.get_bus_index(bus_name)

	if bus == -1:
		push_error("Audio bus not found: " + bus_name)
		return 100.0

	if AudioServer.is_bus_mute(bus):
		return 0.0

	return clampf(
		db_to_linear(AudioServer.get_bus_volume_db(bus)) * 100.0,
		0.0,
		100.0
	)


# Set audio bus volume
func set_bus_volume(bus_name: String, value: float) -> void:
	var bus = AudioServer.get_bus_index(bus_name)

	if bus == -1:
		push_error("Audio bus not found: " + bus_name)
		return

	if value <= 0:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(
			bus,
			linear_to_db(value / 100.0)
		)


func _on_master_changed(value: float) -> void:
	set_bus_volume("Master", value)


func _on_music_changed(value: float) -> void:
	set_bus_volume("Music", value)


func _on_sfx_changed(value: float) -> void:
	set_bus_volume("Gameplay", value)


func _on_ui_changed(value: float) -> void:
	set_bus_volume("UI", value)


func _on_back_button_pressed() -> void:
	SoundManager.general_button_sfx()
	closed.emit()
	queue_free()
	
func _on_display_mode_selected(index: int) -> void:
	match index:
		0: # Fullscreen
			DisplayServer.window_set_mode(
				DisplayServer.WINDOW_MODE_FULLSCREEN
			)

		1: # Windowed
			DisplayServer.window_set_mode(
				DisplayServer.WINDOW_MODE_WINDOWED
			)

			DisplayServer.window_set_size(Vector2i(1280, 720))

			# Center the window
			var screen_size = DisplayServer.screen_get_size()
			var window_size = DisplayServer.window_get_size()

			DisplayServer.window_set_position(
				(screen_size - window_size) / 2
			)

func update_display_mode() -> void:
	var current_mode = DisplayServer.window_get_mode()

	if current_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		display_mode.select(1)
	else:
		display_mode.select(0)
