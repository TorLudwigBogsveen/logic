extends Node2D

var node_input_scene = load("res://NodeParts/NodeInput.tscn")
var node_output_scene = load("res://NodeParts/NodeOutput.tscn")

var inputs = []
var outputs = []

var input_nodes = []
var output_nodes = []

var id = -1
var old_values = []
var values = []

func _ready():
	pass
	
func _input(event):
	if event is InputEventMouse:
		var mouse_pos = get_viewport().get_mouse_position()
		if is_mouse_inside(mouse_pos):
			if event.is_action_pressed("mouse_left"):
				get_parent().select_node()
			elif event.is_action_released("mouse_left"):
				get_parent().unselect_node()
				
func reposition_outputs():
	var window_size = get_viewport_rect().size;
	for i in range(outputs.size()):
		var output = outputs[i]
		output.position.y = (get_size().y / (output_nodes.size() + 1))*(i+1)
		output.position.x = get_size().x+10

func reposition_inputs():
	var window_size = get_viewport_rect().size;
	for i in range(inputs.size()):
		var input = inputs[i]
		input.position.y = (get_size().y / (self.input_nodes.size() + 1))*(i+1)
		input.position.x = -10
		
func set_size(size):
	get_child(0).rect_size = size
	reposition_inputs()
	reposition_outputs()
	
func get_size():
	return get_child(0).rect_size

func get_value(io):
	if io is NodeOutput:
		return old_values[outputs.find(io)]
	elif io is NodeInput:
		return old_values[inputs.find(io)]
	else:
		assert(false)

func is_mouse_inside(mouse_pos):
	return mouse_pos.x >= global_position.x && mouse_pos.x < global_position.x + get_size().x && mouse_pos.y >= global_position.y && mouse_pos.y < global_position.y + get_size().y
	
func remove_inputs():
	for input in inputs:
		remove_child(input)
		
func remove_outputs():
	for output in outputs:
		remove_child(output)

func set_inputs(new_input_nodes):
	remove_inputs()
	
	print(new_input_nodes)
	
	input_nodes = new_input_nodes
	inputs = []
	for i in input_nodes.size():
		var input_node_instance = node_input_scene.instance()
		input_node_instance.id = i
		add_child(input_node_instance)
		inputs.push_back(input_node_instance)
	
	reposition_inputs()
	
	return self
		
func set_outputs(new_output_nodes):
	remove_outputs()
	
	output_nodes = new_output_nodes
	outputs = []
	for i in output_nodes.size():
		var output_node_instance = node_output_scene.instance()
		output_node_instance.id = i
		add_child(output_node_instance)
		outputs.push_back(output_node_instance)
	values.resize(outputs.size())
	values.fill(false)
	old_values.resize(outputs.size())
	old_values.fill(false)
	
	reposition_outputs()
	
	return self
	
func reset():
	old_values = values.duplicate()
	
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
		"inputs": node_inputs,
		"outputs": node_outputs,
		"position_x": global_position.x,
		"position_y": global_position.y
	}
	
	return save_dict
