extends Control

@onready var tv: TextureButton = $SubViewportContainer/SubViewport/Buttons/Play
@onready var bookshelf: TextureButton = $SubViewportContainer/SubViewport/Buttons/Options
@onready var door: TextureButton = $SubViewportContainer/SubViewport/Buttons/Exit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	# Connect furniture click events
	#tv.pressed.connect(_on_play_pressed)
	#bookshelf.pressed.connect(_on_options_pressed)
	#door.pressed.connect(_on_exit_pressed)
	
	## Prepare hover animations
	#for button in [tv, bookshelf, door]:
		#button.pivot_offset = button.size / 2
		#button.mouse_entered.connect(_on_hover.bind(button, true))
		#button.mouse_exited.connect(_on_hover.bind(button, false))
#
#func _on_hover(button: Control, hovering: bool):
	#print(button.name, " hovering: ", hovering)
	#var tween = create_tween()
	#var target_scale = Vector2(1.04, 1.04) if hovering else Vector2.ONE
#
	#tween.tween_property(button, "scale", target_scale, 0.15)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	
	

func _on_options_pressed() -> void:
	pass # Replace with function body.
	

func _on_exit_pressed() -> void:
	pass # Replace with function body.
