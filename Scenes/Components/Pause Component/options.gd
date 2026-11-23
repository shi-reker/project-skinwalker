extends Control

signal closed

@onready var master_slider: HSlider = $SettingsContent/MasterSlider
@onready var music_slider: HSlider = $SettingsContent/MusicSlider
@onready var sfx_slider: HSlider = $SettingsContent/SFXSlider

func _ready() -> void:
	# Initialize slider positions from current audio settings
	master_slider.value = get_bus_slider_value("Master")
	music_slider.value = get_bus_slider_value("Music")
	sfx_slider.value = get_bus_slider_value("SFX")
	
	# Connect signals
	master_slider.value_changed.connect(_on_master_changed)
	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)

func get_bus_slider_value(bus_name: String) -> float:
	var bus = AudioServer.get_bus_index(bus_name)

	if AudioServer.is_bus_mute(bus):
		return 0.0

	return clampf(
		db_to_linear(AudioServer.get_bus_volume_db(bus)) * 100.0,
		0.0,
		100.0
	)
# Change audio bus volume
func set_bus_volume(bus_name: String, value: float) -> void:
	var bus = AudioServer.get_bus_index(bus_name)

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
	set_bus_volume("SFX", value)
	
func _on_back_button_pressed() -> void:
	closed.emit()
	queue_free()
