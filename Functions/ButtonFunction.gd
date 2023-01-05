class_name ButtonFunction

var inputs = []
var outputs = []
var on = false

func reset():
	pass

func run():
	pass

func set_inputs(n_inputs):
	inputs = n_inputs
	
func set_outputs(n_outputs):
	outputs = n_outputs

func get_value(output_node):
	assert(outputs.has(output_node))
	return on
	
