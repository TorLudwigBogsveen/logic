class_name KeyFunction

var inputs = []
var outputs = []
var old_value = false
var value = false
var key = null

func _input(event):

	if event is InputEventKey:
		if event.pressed && event.scancode == key:
			value = true
		elif !event.pressed && event.scancode == key:
			value = false

func reset():
	old_value = value

func run():
	pass

func set_inputs(n_inputs):
	inputs = n_inputs
	
func set_outputs(n_outputs):
	outputs = n_outputs

func get_value(output_node):
	assert(outputs.has(output_node))
	return old_value
	
