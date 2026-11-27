extends Node

var pause_menu: PauseMenu
var world: World

func setup(_world: World, _pause_menu: PauseMenu):
	world = _world
	pause_menu = _pause_menu
	pause_menu.will_queue_free = false
	pause_menu.hide()

func toggle_pause() -> void:
	if pause_menu.visible:
		pause_menu._on_resume_pressed()
	else:
		pause_menu.show()
		get_tree().paused = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()
