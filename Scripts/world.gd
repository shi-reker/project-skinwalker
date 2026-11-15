extends Node2D
class_name World

@export var player: PlayerActor
@export var stalker: StalkerActor

func _ready() -> void:
	player.entered_home.connect(_on_player_entered_home)
	
func _on_player_entered_home():
	print("gone home!")
	if stalker.is_player_detected:
		stalker.detected_player_entered_home()
