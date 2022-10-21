extends Node2D

class_name NodeInput

var radius = 10

var connection = null
var id = -1

func _ready():
	pass 
	
func _process(_delta):
	update()

func _draw():
	var color
	if connection == null || connection.get_value() == false:
		color = Color.white
	else:
		color = Color.red
		
	draw_circle(Vector2(0, 0), radius, color)
	if connection != null:
		draw_line(Vector2(0, 0), connection.global_position-global_position, color, 5.0)

func _input(event):
	if event is InputEventMouse:
		if event.is_action_pressed("mouse_left"):
			if global_position.distance_to(event.position) <= float(radius):
				get_parent().clicked_input(self, BUTTON_LEFT)

func connect_node(other):
	if connection == other:
		return
	if connection != null:
		connection.disconnect_node(self)
	connection = other
	other.connect_node(self)
	
func disconnect_node(other):
	if connection != null:
		connection = null
		other.disconnect_node(self)
		
func get_value():
	if get_parent() != null:
		return get_parent().get_value(self)
	else:
		disconnect_node(connection)
		return false

func id():
	return id

func full_id():
	return {
		"id": id(),
		"parent": get_parent().id(),
	}

func save():
	var save_dict = {
		"id": id(),
		"parent": get_parent().id(),
		"connection": connection.full_id()
	}
	
	return save_dict
