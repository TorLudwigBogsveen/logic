extends Node2D 

var selected_node = null
var selected_io = null

var inputs = []
var outputs = []

var nodes = []

var test_values = {}

var circuit_scene = load("res://Circuits/FunctionCircuit.tscn")
var ssd_scene = load("res://Circuits/SevenSegmentDisplay.tscn")
var btn_scene = load("res://Circuits/Button.tscn")
var key_scene = load("res://Circuits/Key.tscn")
var clock_scene = load("res://Circuits/Clock.tscn")

var node_input_scene = load("res://NodeParts/NodeInput.tscn")
var node_output_scene = load("res://NodeParts/NodeOutput.tscn")

var FunctionCircuit = load("res://Circuits/FunctionCircuit.gd")

var timer = 0
var t = 0

func _ready():
	get_tree().get_root().connect("size_changed", self, "on_resized")

func _draw():
	if selected_io != null:
		draw_line(get_viewport().get_mouse_position(), selected_io.global_position, Color.white, 5.0)

func on_resized():
	reposition_inputs()
	reposition_outputs()
		
func _process(delta):
	timer += delta
	t += 1
	if timer >= 1.0:
		timer -= 1.0
		print("TICK: " + String(t))
		t = 0
	for _i in range(1):
		for node in nodes:
			node.run()
		for node in nodes:
			node.reset()
	if selected_node != null:
		var pos = get_viewport().get_mouse_position()
		var size = selected_node.get_base().get_size()
		selected_node.set_position(Vector2(pos.x-size.x/2, pos.y-size.y/2))
	update()

func set_n_inputs(n_inputs):
	if n_inputs >= 0:
		for input in inputs:
			if get_children().has(input):
				remove_child(input)
		inputs = []
		for i in range(n_inputs):
			var node_input_instance = node_output_scene.instance()
			node_input_instance.id = i
			add_child(node_input_instance)
			inputs.push_back(node_input_instance)
		reposition_inputs()
	
func set_n_outputs(n_outputs):	
	if n_outputs >= 0:
		for output in outputs:
			if get_children().has(output):
				remove_child(output)
		outputs = []
		for i in range(n_outputs):
			var node_output_instance = node_input_scene.instance()
			node_output_instance.id = i
			add_child(node_output_instance)
			outputs.push_back(node_output_instance)
		reposition_outputs()

func reposition_outputs():
	var window_size = get_viewport_rect().size;
	for i in range(outputs.size()):
		var output = outputs[i]
		output.position.y = (window_size.y / (outputs.size() + 1))*(i+1)
		output.position.x = window_size.x-16;

func reposition_inputs():
	var window_size = get_viewport_rect().size;
	for i in range(inputs.size()):
		var input = inputs[i]
		input.position.y = (window_size.y / (inputs.size() + 1))*(i+1)
		input.position.x = 128;

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

func remove_node(node):
	node.get_base().disconnect_all()
	nodes.remove(nodes.find(node))
	node.queue_free()

func id():
	return 0

func rename_nodes(old_name, new_name):
	for node in nodes:
		if node is FunctionCircuit:
			if node.get_name() == old_name:
				node.set_name(new_name)

func load_custom(node_name):
	var file = File.new()
	var error = file.open("user://nodes/"+node_name+".save", File.READ)
	if error:
		push_error("ERORR OPENING FILE : " + String(error))
	var content = file.get_as_text()
	file.close()
	
	var json = JSON.parse(content)
	if json.error != OK:
		push_error("ERROR PARSING JSON")
	
	json = json.result
	$"../Panel/NameField".text = json.name
	$"../Panel/NInputsField".text = String(json.inputs.size())
	$"../Panel/NOutputsField".text = String(json.outputs.size())
	
	get_parent()._on_NameField_text_changed(json.name)
	
	set_n_inputs(json.inputs.size())
	set_n_outputs(json.outputs.size())
	
	delete() #removes old nodes
	
	for node in json.nodes:
		var new_node = spawn_node(node.function)
		new_node.set_position(Vector2(node.position_x, node.position_y))
		
		if node.has("key"):
			print(node)
			print(node.key)
			new_node.set_key(node.key)
		
		nodes.push_back(new_node)
		add_child(new_node)
		
	
	for node in json.nodes:
		for input in node.inputs:
			var this = nodes[input.parent-1]
			if input.connection.parent == 0:
				this.get_base().inputs[input.id].connect_node(inputs[input.connection.id])
			else:
				var other = nodes[input.connection.parent-1]
				this.get_base().inputs[input.id].connect_node(other.get_base().outputs[input.connection.id])
				
	for output in json.outputs:
		outputs[output.id].connect_node(nodes[output.connection.parent-1].get_base().outputs[output.connection.id])

func spawn_node(node_name):
	var node = null
	match node_name:
		"NAND":
			var custom_function = CustomFunction.new()
			custom_function.from_json(
				to_json({
					"name": "NAND",
					"inputs": [
						{"connections": [{"id": 0, "parent": 1}], "id": 0, "parent": 0},
						{"connections": [{"id": 1, "parent": 1}], "id": 1, "parent": 0}
					],
					"outputs": [
						{"connection": {"id": 0, "parent": 1},  "id": 0, "parent": 0}
					],
					"nodes": [
						{
							"function": "NAND",
							"id": 1,
							"inputs": [
								{"connection": {"id": 0, "parent": 0}, "id": 0, "parent": 1},
								{"connection": {"id": 1, "parent": 0}, "id": 1, "parent": 1}
							],
							"outputs": [
								{"connections": [{"id": 0, "parent": 0}], "id": 0, "parent": 1}
							]
						}
					]
				})
			)
			node = circuit_scene.instance()
			node.set_name(custom_function.name).set_function(custom_function)
		"SSD":
			node = ssd_scene.instance()
		"BTN":
			node = btn_scene.instance()
		"KEY":
			node = key_scene.instance()
		"CLOCK":
			node = clock_scene.instance()
		_:
			node = load_node(node_name)
	node.set_id(nodes.size()+1)
	return node

func load_node(node_name):
	var file = File.new()
	file.open("user://nodes/" + node_name + ".save", File.READ)
	var content = file.get_as_text()
	file.close()

	var custom_function = CustomFunction.new()
	custom_function.from_json(content)

	var node = circuit_scene.instance()
	node.set_name(custom_function.name).set_function(custom_function)
	return node

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
	
func create(node):
	selected_node = node
	nodes.push_back(selected_node)
	add_child(selected_node)
	pass

func get_value(io):
	if test_values.has(io):
		return test_values[io]
	else:
		return false
	
