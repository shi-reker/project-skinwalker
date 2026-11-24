extends Node

var all_npcs: Array[NPCActor] = []
var recruited_npcs: Array[NPCActor] = []
var _npc_by_id: Dictionary = {}

func register_npc(npc: NPCActor) -> void:
	if npc == null or npc in all_npcs:
		return
	all_npcs.append(npc)
	_npc_by_id[npc.name] = npc

	print("[NPCManager] Registered: ", npc.name)


func unregister_npc(npc: NPCActor) -> void:
	if npc == null:
		return
	all_npcs.erase(npc)
	recruited_npcs.erase(npc)
	_npc_by_id.erase(npc.name)

	print("[NPCManager] Unregistered: ", npc.name)


func _on_npc_recruited(npc: NPCActor) -> void:
	if npc == null or npc in recruited_npcs:
		return
	recruited_npcs.append(npc)
	print("[NPCManager] Recruited: ", npc.name, " (total: ", recruited_npcs.size(), ")")


func get_all_npcs() -> Array[NPCActor]:
	return all_npcs.duplicate()


func get_recruited_npcs() -> Array[NPCActor]:
	return recruited_npcs.duplicate()


func get_recruited_count() -> int:
	return recruited_npcs.size()


func get_total_count() -> int:
	return all_npcs.size()


func get_npc_by_name(npc_name: String) -> NPCActor:
	return _npc_by_id.get(npc_name, null)


func is_recruited(npc: NPCActor) -> bool:
	return npc in recruited_npcs


func reset() -> void:
	all_npcs.clear()
	recruited_npcs.clear()
	_npc_by_id.clear()
	print("[NPCManager] Reset")
