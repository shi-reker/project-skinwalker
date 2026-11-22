extends Node

enum NpcId {NONE, NEIGHBOR}

var npc_resource: Dictionary[NpcId, NPCDefinition] = {
	NpcId.NONE: preload("res://Resources/NPCs/guy1.tres")
}

var npc_statuses: Dictionary[NpcId, int] = {}

func setup(world: World):
	pass
func add_npc(npc: NpcId):
	npc_statuses[npc] = 0
	
