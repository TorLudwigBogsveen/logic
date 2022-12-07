extends "res://Circuits/CircuitBase.gd"

var function = null

func set_name(name):
	get_child(1).text = name
	return self

func set_function(new_function):
	function = new_function
	var new_inputs = []
	new_inputs.resize(function.inputs.size())
	get_base().set_inputs(new_inputs)
	var new_outputs = []
	new_outputs.resize(function.outputs.size())
	get_base().set_outputs(new_outputs)
	return self
	
func reset():
	.reset()	
	self.function.reset()
	
func save():
	var s = .save()
	s["function"] = self.function.name
	return s

func run():
	var input_values = []
	for i in range(get_base().inputs.size()):
		var c = get_base().inputs[i].connection
		if c != null:
			input_values.push_back(c.get_value())
		else:
			input_values.push_back(false)
	self.function.input_values = input_values
	self.function.run()
	var output_values = self.function.get_output_values()
	get_base().values = output_values
	
	return self
