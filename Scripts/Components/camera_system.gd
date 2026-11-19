extends Camera2D

enum Modes{
	SCHOOL,
	WORLD
}

@export var speed := 400.0
@export var edge_margin := 20.0   # pixels from the screen edge
@export var mode:Modes

func _ready() -> void:
	# Keeps the cursor inside the window so it can actually reach the edge
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

	# Map bounds (adjust to your level size)
	#limit_left = 0
	#limit_right = 0
	#limit_top = 0
	#limit_bottom = 346

func _process(delta: float) -> void:
	var mouse := get_viewport().get_mouse_position()
	var size := get_viewport().get_visible_rect().size
	var dir := Vector2.ZERO

	if mouse.x <= edge_margin:
		dir.x -= 1
	elif mouse.x >= size.x - edge_margin:
		dir.x += 1

	if mouse.y <= edge_margin:
		dir.y -= 1
	elif mouse.y >= size.y - edge_margin:
		dir.y += 1
	
	var posQueue:Vector2 = position + dir.normalized() * speed * delta
	match mode:
		Modes.SCHOOL:
			if posQueue.y < limit_bottom and posQueue.y > limit_top:
				position += dir.normalized() * speed * delta
				if limit_right == 0 and limit_left == 0:
					#print_debug("zero")
					position.x = 0
		Modes.WORLD:
			position += dir.normalized() * speed * delta
	
