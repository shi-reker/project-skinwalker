extends Area2D
class_name Home

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerActor:
		var player := body as PlayerActor
		player.set_interaction_available(true)
		player.entered_home.emit()

func _on_body_exited(body: Node2D) -> void:
	if body is PlayerActor:
		var player := body as PlayerActor
		player.set_interaction_available(false)
