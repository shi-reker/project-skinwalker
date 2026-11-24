extends Resource
class_name NPCAbility

## Base class untuk semua kemampuan NPC.
## Setiap ability adalah Resource yang di-attach ke NPCDefinition.

@export var ability_name: String = "Ability"
@export_multiline var description: String = ""
@export var cooldown: float = 5.0

var _cooldown_timer: float = 0.0
var _is_active: bool = false
var _owner_npc: NPCActor = null


func setup(owner_npc: NPCActor) -> void:
	_owner_npc = owner_npc


func can_activate() -> bool:
	return not _is_active and _cooldown_timer <= 0.0 and _owner_npc != null


func activate(_context: Dictionary = {}) -> void:
	if not can_activate():
		return
	_is_active = true
	_on_activate(_context)


func deactivate() -> void:
	if not _is_active:
		return
	_is_active = false
	_on_deactivate()


func update(delta: float) -> void:
	if _cooldown_timer > 0.0:
		_cooldown_timer -= delta
	if _is_active:
		_on_update(delta)


func is_active() -> bool:
	return _is_active


func get_owner_npc() -> NPCActor:
	return _owner_npc


# --- Virtual methods (override di subclass) ---

func _on_activate(_context: Dictionary) -> void:
	pass


func _on_deactivate() -> void:
	pass


func _on_update(_delta: float) -> void:
	pass


# --- Helper untuk subclass ---

func _start_cooldown() -> void:
	_cooldown_timer = cooldown
