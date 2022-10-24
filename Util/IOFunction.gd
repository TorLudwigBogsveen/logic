class_name IOFunction

var inputs = []
var outputs = []
var parent = null

func _init(new_parent):
	parent = new_parent

func run():
	pass
	
func set_n_io(n_io):
	set_n_inputs(n_io)
	set_n_outputs(n_io)
		
func set_n_inputs(n_inputs):
	inputs = []
	for _i in range(n_inputs):
		var input = FunctionInput.new()
		inputs.push_back(input)

func set_n_outputs(n_outputs):
	outputs = []
	for _i in range(n_outputs):
		var output = FunctionOutput.new()
		output.parent = self
		outputs.push_back(output)

func get_value(output):
	assert(outputs.has(output))
	var input = inputs[outputs.find(output)]
	if input.connected != null:
		return input.get_value()
	else:
		return parent.get_value(output)
