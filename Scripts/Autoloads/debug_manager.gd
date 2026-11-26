extends Node

var debug_label: Label
var _debug_elapsed: float = 0

func setup(_debug_label: Label):
	debug_label = _debug_label
	debug_label.show()
	print_debug("yesssss")

func _process(delta: float) -> void:
	_debug_elapsed += delta
	if _debug_elapsed >= 1.0:
		debug_label.text = "debug turned on"
	_debug_elapsed = 0.0

func add_debug(text: String, node_name: String = ""):
	if debug_label != null:
		debug_label.text = "showing"
		debug_label.text += "\n"+ node_name + " " + text
	else: 
		print_debug("whereeeee")
