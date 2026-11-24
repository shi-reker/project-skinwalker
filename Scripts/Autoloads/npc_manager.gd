extends Node

enum NpcId {NONE, NEIGHBOR}

var npc_resource: Dictionary[NpcId, NPCDefinition] = {
	NpcId.NONE: preload("res://Resources/NPCs/guy1.tres")
}

var npc_statuses: Dictionary[NpcId, int] = {}

var all_npcs: Array[NPCActor] = []
var recruited_npcs: Array[NPCActor] = []
var _npc_by_id: Dictionary = {}

var world: World

func _ready() -> void:
	npc_statuses = randomize_npc()

func setup(_world: World):
	world = _world
	
	var npc_scene := load("res://Scenes/Actors/npc.tscn")
	for npc in npc_statuses.keys():
		var npc_def: NPCDefinition = npc_resource[npc]
	pass

func randomize_npc() -> Dictionary[NpcId, int]:
	return {NpcId.NONE: 0}
	
func add_npc(npc: NpcId):
	npc_statuses[npc] = 0
	
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
	npc.npc_definition.ability.activate(world)
	print("[NPCManager] Recruited: ", npc.name, " (total: ", recruited_npcs.size(), ")")
