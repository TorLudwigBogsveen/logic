extends Node2D

var input_node_scene = load("res://NodeParts/NodeInput.tscn")
var output_node_scene = load("res://NodeParts/NodeOutput.tscn")

var inputs = null
var outputs = null

var function = null

var input_nodes = null
var output_nodes = null

var id = -1
var values = []

func _ready():
	pass
	
func _input(event):
	if event is InputEventMouse:
		var mouse_pos = get_viewport().get_mouse_position()
		if is_mouse_inside(mouse_pos):
			if event.is_action_pressed("mouse_left"):
				get_parent().selected_node = self
			elif event.is_action_released("mouse_left"):
				get_parent().selected_node = null
		
func get_value(io):
	if io is NodeOutput:
		return values[outputs.find(io)]
	elif io is NodeInput:
		return values[inputs.find(io)]
	else:
		assert(false)

func is_mouse_inside(mouse_pos):
	return mouse_pos.x >= global_position.x && mouse_pos.x < global_position.x + 128 && mouse_pos.y >= global_position.y && mouse_pos.y < global_position.y + 128

func set_name(name):
	get_child(1).text = name
	return self

func set_function(new_function):
	function = new_function
	var new_inputs = []
	new_inputs.resize(function.inputs.size())
	set_inputs(new_inputs)
	var new_outputs = []
	new_outputs.resize(function.outputs.size())
	set_outputs(new_outputs)
	return self
	
func set_inputs(new_input_nodes):
	input_nodes = new_input_nodes
	inputs = []
	for i in input_nodes.size():
		var input_node_instance = input_node_scene.instance()
		input_node_instance.position.y = (128 / (self.input_nodes.size() + 1))*(i+1)
		input_node_instance.position.x = -10;
		input_node_instance.id = i
		add_child(input_node_instance)
		inputs.push_back(input_node_instance)
	return self
		
func set_outputs(new_output_nodes):
	output_nodes = new_output_nodes
	outputs = []
	for i in output_nodes.size():
		var output_node_instance = output_node_scene.instance()
		output_node_instance.position.y = (128 / (output_nodes.size() + 1))*(i+1)
		output_node_instance.position.x = 128+10;
		output_node_instance.id = 0
		add_child(output_node_instance)
		outputs = [output_node_instance]
	values.resize(outputs.size())
	values.fill(false)
	return self

func run():
	var input_values = []
	for i in range(inputs.size()):
		var c = inputs[i].connection
		if c != null:
			input_values.push_back(c.get_value())
		else:
			input_values.push_back(false)
	self.function.input_values = input_values
	self.function.run()
	var output_values = self.function.get_output_values()
	values = output_values
	return self
	
func clicked_input(input, btn):
	get_parent().clicked_input(input, btn)

func clicked_output(output, btn):
	get_parent().clicked_output(output, btn)
	
func id():
	return id

func save():
	var node_inputs = []
	for input in inputs:
		node_inputs.push_back(input.save())
	
	var node_outputs = []
	for output in outputs:
		node_outputs.push_back(output.save())
	
	var save_dict = {
		"id": id(),
		"function": function.name,
		"inputs": node_inputs,
		"outputs": node_outputs
	}
	
	return save_dict
