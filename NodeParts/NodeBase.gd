extends Node2D

var node_input_scene = load("res://NodeParts/NodeInput.tscn")
var node_output_scene = load("res://NodeParts/NodeOutput.tscn")

var inputs = []
var outputs = []

var id = -1
var old_values = []
var values = []

enum RightClickMenuButton {
	DELETE = 0,
	DISCONNECT = 1
}

func _ready():
	pass

func get_input_values():
	var input_values = []
	for i in range(inputs.size()):
		var c = inputs[i].connection
		if c != null:
			input_values.push_back(c.get_value())
		else:
			input_values.push_back(false)
	return input_values

func disconnect_all():
	for input in inputs:
		input.disconnect_node()
	
	for output in outputs:
		output.disconnect_all()
				
func open_menu():
	var popup = PopupMenu.new()
	var mouse = get_viewport().get_mouse_position()
	
	add_child(popup)
	popup.add_item("Delete", RightClickMenuButton.DELETE)
	popup.add_item("Disconnect", RightClickMenuButton.DISCONNECT)
	
	get_parent().open_menu(popup)
	
	popup.connect("popup_hide", self, "remove_child", [popup])
	popup.connect("id_pressed", self, "menu_button_pressed")
	
	popup.popup_centered(Vector2(0, 0))
	popup.rect_position = Vector2(mouse.x, mouse.y)
	
	pass				

func menu_button_pressed(action):
	match action:
		RightClickMenuButton.DELETE:
			get_parent().get_parent().remove_node(get_parent())
		RightClickMenuButton.DISCONNECT:
			disconnect_all()
		_:
			get_parent().menu_button_pressed(action)
	pass

func reposition_outputs():
	for i in range(outputs.size()):
		var output = outputs[i]
		output.position.y = (get_size().y / (outputs.size() + 1))*(i+1)
		output.position.x = get_size().x+10

func reposition_inputs():
	for i in range(inputs.size()):
		var input = inputs[i]
		input.position.y = (get_size().y / (inputs.size() + 1))*(i+1)
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

func set_n_inputs(n_inputs):
	remove_inputs()
	
	inputs = []
	for i in range(n_inputs):
			var node_input_instance = node_input_scene.instance()
			node_input_instance.id = i
			add_child(node_input_instance)
			inputs.push_back(node_input_instance)
	
	reposition_inputs()
	
	return self
		
func set_n_outputs(n_outputs):
	remove_outputs()
	
	outputs = []
	for i in range(n_outputs):
		var node_output_instance = node_output_scene.instance()
		node_output_instance.id = i
		add_child(node_output_instance)
		outputs.push_back(node_output_instance)
		
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

func _on_Panel_gui_input(event):
	if event is InputEventMouse:
		var mouse_pos = get_viewport().get_mouse_position()
		if is_mouse_inside(mouse_pos):
			if event.is_action_pressed("mouse_right"):
				open_menu()
			if event.is_action_pressed("mouse_left"):
				get_parent().select_node()
			elif event.is_action_released("mouse_left"):
				get_parent().unselect_node()
