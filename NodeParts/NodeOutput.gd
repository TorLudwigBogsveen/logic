extends Node2D

class_name NodeOutput

var radius = 10

var connections = []
var id = -1

func _ready():
	pass 

func _process(_delta):
	update()

func _draw():
	if get_value() == false:
		draw_circle(Vector2(0, 0), radius, Color.white)
	else:
		draw_circle(Vector2(0, 0), radius, Color.red)
		
func _input(event):
	if event is InputEventMouse:
		if event.is_action_pressed("mouse_left"):
			if global_position.distance_to(event.position) <= float(radius):
				get_parent().clicked_output(self, BUTTON_LEFT)
		elif event.is_action_pressed("mouse_right"):
			if global_position.distance_to(event.position) <= float(radius):
				get_parent().clicked_output(self, BUTTON_RIGHT)

func connect_node(other):
	if !connections.has(other):
		connections.append(other)
	other.connect_node(self)
	
func disconnect_node(other):
	if connections.has(other):
		other.disconnect_node(self)
		connections.erase(other)

func disconnect_all():
	var cs = connections;
	connections = []
	for c in cs:
		c.disconnect_node(self)

func get_value():
	if get_parent() != null:
		return get_parent().get_value(self)
	else:
		disconnect_all()
		return false

func id():
	return id
	
func full_id():
	return {
		"id": id(),
		"parent": get_parent().id(),
	}

func save():
	var cs = []
	for c in connections:
		cs.push_back(c.full_id())
	var save_dict = {
		"id": id(),
		"parent": get_parent().id(),
		"connections": cs
	}
	
	return save_dict
