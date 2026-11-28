
@tool
extends Node2D
class_name AudioSource2D


enum RangeShape {
	CIRCLE,
	RECTANGLE,
	CONE,
	CAPSULE
}


@export_group("Audio Settings")
@export_file("*.wav", "*.ogg", "*.mp3") var sound_path: String = ""
@export_range(-40.0, 10.0, 0.5) var volume: float = 0.0
@export var loop: bool = true
@export var audio_bus: StringName = &"Gameplay"

@export_group("Detection Settings")
@export var player_group: StringName = &"player"

@export_group("Range Settings")
@export var show_hearing_range: bool = true:
	set(value):
		show_hearing_range = value
		queue_redraw()
		
@export_group("Fade Settings")
@export_range(0.1, 10.0, 0.1) var fade_in_duration: float = 0.5
@export_range(0.1, 10.0, 0.1) var fade_out_duration: float = 2.0

var fade_tween: Tween
@export var range_shape: RangeShape = RangeShape.CIRCLE:
	set(value):
		range_shape = value
		_update_range()

@export_range(0.0, 2000.0, 1.0) var hearing_range: float = 300.0:
	set(value):
		hearing_range = value
		_update_range()

@export var rectangle_size: Vector2 = Vector2(400.0, 300.0):
	set(value):
		rectangle_size = value
		_update_range()

@export_range(1.0, 360.0, 1.0) var cone_angle: float = 90.0:
	set(value):
		cone_angle = value
		_update_range()

@export var range_color: Color = Color(0.2, 0.8, 1.0, 0.3):
	set(value):
		range_color = value
		queue_redraw()


@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var detection_area: Area2D = $DetectionArea
@onready var collision_shape: CollisionShape2D = $DetectionArea/CollisionShape2D



func _ready() -> void:
	queue_redraw()

	if Engine.is_editor_hint():
		return

	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)

	_update_collision_shape()
	_setup_audio()


func _update_range() -> void:
	queue_redraw()

	if is_node_ready() and not Engine.is_editor_hint():
		_update_collision_shape()
		_update_audio_distance()


func _setup_audio() -> void:
	audio_player.bus = audio_bus
	audio_player.volume_db = volume

	_update_audio_distance()

	if sound_path.is_empty():
		return

	var loaded_audio: AudioStream = load(sound_path) as AudioStream

	if loaded_audio == null:
		push_error("Failed to load audio: " + sound_path)
		return

	audio_player.stream = loaded_audio.duplicate() as AudioStream

	if loop:
		if audio_player.stream is AudioStreamWAV:
			var wav: AudioStreamWAV = audio_player.stream as AudioStreamWAV
			wav.loop_mode = AudioStreamWAV.LOOP_FORWARD

		elif audio_player.stream is AudioStreamOggVorbis:
			var ogg: AudioStreamOggVorbis = audio_player.stream as AudioStreamOggVorbis
			ogg.loop = true


func _update_audio_distance() -> void:
	var distance: float = hearing_range

	if range_shape == RangeShape.RECTANGLE:
		distance = rectangle_size.length() / 2.0

	elif range_shape == RangeShape.CAPSULE:
		distance = hearing_range

	audio_player.max_distance = maxf(distance + 20.0, 1.0)


func _update_collision_shape() -> void:
	if not is_instance_valid(collision_shape):
		return

	var new_shape: Shape2D = null

	match range_shape:

		RangeShape.CIRCLE:
			var circle: CircleShape2D = CircleShape2D.new()
			circle.radius = hearing_range
			new_shape = circle

		RangeShape.RECTANGLE:
			var rectangle: RectangleShape2D = RectangleShape2D.new()
			rectangle.size = rectangle_size
			new_shape = rectangle

		RangeShape.CONE:
			var points: PackedVector2Array = PackedVector2Array()
			points.append(Vector2.ZERO)

			var half_angle: float = deg_to_rad(cone_angle / 2.0)

			for i: int in range(33):
				var weight: float = float(i) / 32.0
				var angle: float = -half_angle + (2.0 * half_angle * weight)

				var point: Vector2 = Vector2.RIGHT.rotated(angle) * hearing_range
				points.append(point)

			var polygon: ConvexPolygonShape2D = ConvexPolygonShape2D.new()
			polygon.points = points
			new_shape = polygon

		RangeShape.CAPSULE:
			var capsule: CapsuleShape2D = CapsuleShape2D.new()
			capsule.radius = hearing_range / 2.0
			capsule.height = hearing_range * 2.0
			new_shape = capsule

	collision_shape.shape = new_shape

	if range_shape == RangeShape.CAPSULE:
		collision_shape.rotation_degrees = 90.0
	else:
		collision_shape.rotation_degrees = 0.0


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group(player_group):
		return

	if audio_player.stream == null:
		return

	if fade_tween and fade_tween.is_running():
		fade_tween.kill()

	if not audio_player.playing:
		audio_player.volume_db = -80.0
		audio_player.play()

	fade_tween = create_tween()
	fade_tween.tween_property(
		audio_player,
		"volume_db",
		volume,
		fade_in_duration
	)

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group(player_group):
		return

	if fade_tween and fade_tween.is_running():
		fade_tween.kill()

	fade_tween = create_tween()
	fade_tween.tween_property(
		audio_player,
		"volume_db",
		-80.0,
		fade_out_duration
	)

	fade_tween.tween_callback(audio_player.stop)

func play_sound() -> void:
	if audio_player.stream != null:
		audio_player.play()


func stop_sound() -> void:
	audio_player.stop()


func _draw() -> void:
	if not show_hearing_range:
		return

	var fill_color: Color = Color(
		range_color.r,
		range_color.g,
		range_color.b,
		0.08
	)

	match range_shape:
		RangeShape.CIRCLE:
			_draw_circle(fill_color)

		RangeShape.RECTANGLE:
			_draw_rectangle(fill_color)

		RangeShape.CONE:
			_draw_cone(fill_color)

		RangeShape.CAPSULE:
			_draw_capsule(fill_color)


func _draw_circle(fill_color: Color) -> void:
	draw_circle(Vector2.ZERO, hearing_range, fill_color)
	draw_arc(Vector2.ZERO, hearing_range, 0.0, TAU, 64, range_color, 2.0)


func _draw_rectangle(fill_color: Color) -> void:
	var rect: Rect2 = Rect2(
		-rectangle_size / 2.0,
		rectangle_size
	)

	draw_rect(rect, fill_color)
	draw_rect(rect, range_color, false, 2.0)


func _draw_cone(fill_color: Color) -> void:
	var points: PackedVector2Array = PackedVector2Array()
	points.append(Vector2.ZERO)

	var half_angle: float = deg_to_rad(cone_angle / 2.0)

	for i: int in range(33):
		var weight: float = float(i) / 32.0
		var angle: float = -half_angle + (2.0 * half_angle * weight)

		points.append(Vector2.RIGHT.rotated(angle) * hearing_range)

	draw_colored_polygon(points, fill_color)

	for i: int in range(1, points.size() - 1):
		draw_line(points[i], points[i + 1], range_color, 2.0)

	draw_line(Vector2.ZERO, points[1], range_color, 2.0)
	draw_line(Vector2.ZERO, points[points.size() - 1], range_color, 2.0)


func _draw_capsule(fill_color: Color) -> void:
	var radius: float = hearing_range / 2.0
	var offset: float = radius
	var points: PackedVector2Array = PackedVector2Array()

	for i: int in range(33):
		var angle: float = -PI / 2.0 + PI * float(i) / 32.0
		var point: Vector2 = Vector2(offset, 0.0) + Vector2(cos(angle), sin(angle)) * radius
		points.append(point)

	for i: int in range(33):
		var angle: float = PI / 2.0 + PI * float(i) / 32.0
		var point: Vector2 = Vector2(-offset, 0.0) + Vector2(cos(angle), sin(angle)) * radius
		points.append(point)

	draw_colored_polygon(points, fill_color)

	for i: int in range(points.size()):
		var next_index: int = (i + 1) % points.size()
		draw_line(points[i], points[next_index], range_color, 2.0)
