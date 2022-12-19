class_name ClockFunction

var inputs = []
var outputs = []
var old_value = false
var value = false

var tick_speed = 1
var ticks: int = 0

func run():
	ticks += 1
	if ticks % int(tick_speed) == 0:
		value = !value

func reset():
	old_value = value

func set_inputs(n_inputs):
	inputs = n_inputs
	
func set_outputs(n_outputs):
	outputs = n_outputs

func get_value(output_node):
	assert(outputs.has(output_node))
	return old_value
