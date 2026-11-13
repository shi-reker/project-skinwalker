extends CharacterBody2D
class_name NPCActor

@export var npc_definition: NPCDefinition
@onready var movement_component: MovementComponent = $Components/MovementComponent
@onready var dialogue_component: DialogueComponent = $Components/DialogueComponent
@onready var state_machine: NPCStateMachine = $StateMachine
