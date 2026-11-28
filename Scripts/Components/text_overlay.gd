extends TextureRect

const FADE_IN := 0.7
#const FLICKER := 0.07
const FADE_OUT := 0.6

@export var timer:Timer

func _ready() -> void:
	timer.start(2)
	SpawnAnimation()

func SpawnAnimation() -> void:
	modulate.a = 0.0
	await get_tree().process_frame
	
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, FADE_IN)

func CompleteAnimation() -> void:
	modulate.a = 1.0
	await get_tree().process_frame
	
	var tween := create_tween()
	for i in 4:
		var FLICKER = randf_range(0.04, 0.1)
		var mod = randf_range(0.6, 0.9)
		tween.tween_property(self, "modulate:a", 0.0, FLICKER)
		tween.tween_property(self, "modulate:a", mod, FLICKER)
	tween.tween_property(self, "modulate:a", 0.0, FADE_OUT)
	
	await tween.finished

func _on_timer_timeout() -> void:
	CompleteAnimation()
