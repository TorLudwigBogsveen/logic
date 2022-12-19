extends "res://Circuits/CircuitBase.gd"

var function = null

func set_name(name):
	get_child(1).set_text(name)
	return self

func set_function(new_function):
	function = new_function
	init()
	return self

func init():
	var text_node = get_child(1)

	var max_size_y = max(function.inputs.size(), function.outputs.size()) * 10 * 3
	var max_size_x = text_node.get_size().x * 0.4
	get_base().set_size(Vector2(max_size_x, max_size_y))
	text_node.set_position(Vector2(0, max_size_y/2 - 16))

	var new_inputs = []
	new_inputs.resize(function.inputs.size())
	get_base().set_inputs(new_inputs)
	var new_outputs = []
	new_outputs.resize(function.outputs.size())
	get_base().set_outputs(new_outputs)
	
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

func _input(event):
	if function != null:
		function._input(event)
	
func _on_Label_resized():
	init()
