extends "res://Circuits/CircuitBase.gd"

var selected = false
var key = null

func _ready():
	get_base().set_n_outputs(1)
	
func save():
	var s = .save()
	s["function"] = "KEY"
	s["key"] = key
	return s

func set_key(new_key):
	key = new_key
	if key != null:
		get_child(1).text = ""+char(key)
	else:
		get_child(1).text = "[KEY]"

func _input(event):
	if event is InputEventMouse:
		var mouse_pos = get_viewport().get_mouse_position()
		if is_mouse_inside(mouse_pos):
			if event.is_action_pressed("mouse_right"):
				selected = true
		else:
			if event.is_action_pressed("mouse_right"):
				selected = false
	elif event is InputEventKey:
		if selected && event.pressed:
			selected = false
			set_key(event.scancode)
		elif event.pressed && event.scancode == key:
			get_base().values = [true]
		elif !event.pressed && event.scancode == key:
			get_base().values = [false]
