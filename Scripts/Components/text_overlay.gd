extends TextureRect

@export var timer:Timer

func _ready() -> void:
	timer.start(3)

func _on_timer_timeout() -> void:
	hide()
