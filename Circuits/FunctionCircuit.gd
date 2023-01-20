extends "res://Circuits/CircuitBase.gd"

var function = null

func set_name(name):
	get_child(1).set_text(name)
	resize()
	return self
	
func get_name():
	return get_child(1).get_text()
	

func set_function(new_function):
	function = new_function
	#init() //This will init before node enters a scene which will cause errors
	return self
		
func resize():
	var text_node = get_child(1)
	if function == null:
		return
		
	var max_size_y = max(max(function.n_inputs(), function.n_outputs()) * 10 * 3, text_node.get_minimum_size().y)
	var max_size_x = text_node.get_minimum_size().x * 0.4
	get_base().set_size(Vector2(max_size_x, max_size_y))
	text_node.set_position(Vector2(0, max_size_y/2 - 16))

func init():
	resize()

	get_base().set_n_inputs(function.n_inputs())
	get_base().set_n_outputs(function.n_outputs())
	
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
