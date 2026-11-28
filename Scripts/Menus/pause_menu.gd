extends Control
class_name PauseMenu

signal resumed

const SETTINGS_SCENE = preload("res://Scenes/Components/Pause Component/options.tscn")
const MAIN_MENU_SCENE = "res://Scenes/main_menu.tscn"

@onready var resume_button: Button = $PauseContent/ResumeButton
@onready var options_button: Button = $PauseContent/OptionsButton
@onready var main_menu_button: Button = $PauseContent/MainMenuButton

var will_queue_free: bool = true

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	resume_button.pressed.connect(_on_resume_pressed)
	options_button.pressed.connect(_on_options_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)


# Resume gameplay
func _on_resume_pressed() -> void:
	get_tree().paused = false
	resumed.emit()
	if not will_queue_free:
		hide()
		return
	queue_free()


# Open existing Settings scene
func _on_options_pressed() -> void:
	var settings = SETTINGS_SCENE.instantiate()
	settings.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(settings)


# Return to main menu
func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
