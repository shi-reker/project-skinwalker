extends Area2D
class_name InteractableComponent

@export var interact_name: String = ""
@export var is_interactable: bool = true
@export var weight: ItemManager.Weight = ItemManager.Weight.NONE

var progress_bar: ProgressBar = null
var interact: Callable = func (): pass

var _holding: bool = false
var _hold_progress: float = 0.0
var _hold_duration: float = 0.0
var _tween: Tween = null

const WEIGHT_DURATION := {
	ItemManager.Weight.LIGHT: 10,
	ItemManager.Weight.MEDIUM: 20,
	ItemManager.Weight.HEAVY: 30,
}

func setup(name: String = "", _weight: ItemManager.Weight = ItemManager.Weight.NONE, _interact: Callable = Callable()):
	if name!= "":
		interact_name = name 
	if _weight != ItemManager.Weight.NONE:
		weight = _weight
		progress_bar = ProgressBar.new()
		add_child(progress_bar)
	if _interact.is_valid():
		interact = _interact

func begin_hold() -> void:
	if not is_interactable:
		return
	if not WEIGHT_DURATION.has(weight):
		# NONE should never reach here, but guard anyway
		interact.call()
		return

	_holding = true
	_hold_duration = WEIGHT_DURATION[weight]
	_hold_progress = 0.0
	_show_progress_bar()

	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(progress_bar, "value", progress_bar.max_value, _hold_duration)
	_tween.finished.connect(_on_hold_finished)

func cancel_hold() -> void:
	_holding = false
	if _tween:
		_tween.kill()
		_tween = null
	_hide_progress_bar()
	_hold_progress = 0.0

func _on_hold_finished() -> void:
	if not _holding:
		return
	_holding = false
	_hide_progress_bar()
	if interact.is_valid():
		interact.call()

func _show_progress_bar() -> void:
	if progress_bar == null:
		return
	progress_bar.value = 0.0
	progress_bar.visible = true

func _hide_progress_bar() -> void:
	if progress_bar == null:
		return
	progress_bar.visible = false

func interact_with_player() -> void:
	if not is_interactable:
		return
	if weight == ItemManager.Weight.NONE and interact.is_valid():
		interact.call()
