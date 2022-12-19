class_name NandFunction

var inputs = []
var outputs = []
var old_value = false
var value = false

func reset():
	old_value = value

func run():
	value = !(inputs[0].get_value() && inputs[1].get_value())

func set_inputs(n_inputs):
	inputs = n_inputs
	
func set_outputs(n_outputs):
	outputs = n_outputs

func get_value(output_node):
	assert(outputs.has(output_node))
	return old_value
	
