extends Node2D 

var selected_node = null
var selected_io = null

var inputs = []
var outputs = []

var nodes = []

var test_values = {}

var node_base = load("res://NodeParts/NodeBase.tscn")
var input_node_scene = load("res://NodeParts/NodeInput.tscn")
var output_node_scene = load("res://NodeParts/NodeOutput.tscn")

func _draw():
	if selected_io != null:
		draw_line(get_viewport().get_mouse_position(), selected_io.global_position, Color.white, 5.0)


func _process(_delta):
	for child in get_children():
		if !(child is NodeInput || child is NodeOutput):
			child.run()
	if selected_node != null:
		var pos = get_viewport().get_mouse_position()
		selected_node.set_position(Vector2(pos.x-64, pos.y-64))
	update()

func set_n_inputs(n_inputs):
	if n_inputs >= 0:
		for input in inputs:
			remove_child(input)
		inputs = []
		for i in range(n_inputs):
			var input_node_instance = output_node_scene.instance()
			input_node_instance.position.y = (600 / (n_inputs + 1))*(i+1)
			input_node_instance.position.x = 128;
			input_node_instance.id = i
			add_child(input_node_instance)
			inputs.push_back(input_node_instance)
	
func set_n_outputs(n_outputs):
	if n_outputs >= 0:
		for output in outputs:
			remove_child(output)
		outputs = []
		for i in range(n_outputs):
			var output_node_instance = input_node_scene.instance()
			output_node_instance.position.y = (600 / (n_outputs + 1))*(i+1)
			output_node_instance.position.x = 1024-16;
			output_node_instance.id = i
			add_child(output_node_instance)
			outputs.push_back(output_node_instance)
		
func clicked_input(input, btn):
	if btn == BUTTON_LEFT:
		if selected_io == null:
			selected_io = input
		elif selected_io is NodeOutput:
			selected_io.connect_node(input)
			selected_io = null
		else:
			selected_io = input
			update()
	else:
		pass

func clicked_output(output, btn):
	if btn == BUTTON_LEFT:
		if selected_io == null:
			selected_io = output
		elif selected_io is NodeInput:
			selected_io.connect_node(output)
			selected_io = null
		else:
			selected_io = output
		update()
	elif btn == BUTTON_RIGHT:
		if test_values.has(output):
			test_values[output] = !test_values[output]
		else:
			test_values[output] = true


	
func delete():
	for node in get_children():
		remove_child(node)
	selected_io = null
	selected_node = null
	nodes = []

	set_n_inputs(inputs.size())
	set_n_outputs(outputs.size())
	test_values = {}
	

func id():
	return 0
	
func save_custom(node_name):
	var dir = Directory.new()
	dir.open("user://")
	dir.make_dir("nodes")
	
	var save_game = File.new()
	var error = save_game.open("user://nodes/"+node_name+".save", File.WRITE)
	if error:
		push_error("ERORR OPENING FILE : " + String(error))
	
	var node_inputs = []
	for input in inputs:
		node_inputs.push_back(input.save())
	
	var node_outputs = []
	for output in outputs:
		node_outputs.push_back(output.save())
		
	var nodes_saved = []
	for node in nodes:
		nodes_saved.push_back(node.save())
		
	var save_dict = {
		"name": node_name,
		"inputs": node_inputs,
		"outputs": node_outputs,
		"nodes": nodes_saved
	}
	
	print(to_json(save_dict))
	
	save_game.store_line(to_json(save_dict))
	save_game.close()
	
func create(custom_function):
	selected_node = node_base.instance()
	selected_node.id = nodes.size()+1
	selected_node.set_name(custom_function.name).set_function(custom_function)
	nodes.push_back(selected_node)
	add_child(selected_node)
	pass

func get_value(io):
	if test_values.has(io):
		return test_values[io]
	else:
		return false
	
