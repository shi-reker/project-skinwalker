extends Node2D
class_name World

@export var player: PlayerActor
@export var stalker: StalkerActor
@export var home: House

func _ready() -> void:
	if home != null:
		EnvironmentManager.set_home(home)
	if stalker != null:
		stalker.add_hint()
	#NpcManager.setup(self)
	Events.home_entered.connect(_on_player_entered_home)
	#Events.player_captured.connect(_on_player_captured)

func _on_player_entered_home():
	print("gone home!")
	if stalker.is_player_detected:
		stalker.detected_player_entered_home()

func _on_player_captured():
	print_debug("YOU LOSEEEEE")
