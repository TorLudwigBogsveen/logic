extends "res://Circuits/CircuitBase.gd"

var selected = false
var key = null

func _ready():
	get_base().set_outputs([0])

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
			key = event.scancode
			get_child(1).text = ""+char(key)	
		elif event.pressed && event.scancode == key:
			get_base().values = [!get_base().values[0]]


func is_mouse_inside(mouse_pos):
	return mouse_pos.x >= global_position.x && mouse_pos.x < global_position.x + 128 && mouse_pos.y >= global_position.y && mouse_pos.y < global_position.y + 128
	