extends "res://Circuits/CircuitBase.gd"

var on = false;

func _ready():
	get_base().set_outputs([0])

func _input(event):
	if event is InputEventMouse:
		var mouse_pos = get_viewport().get_mouse_position()
		if is_mouse_inside(mouse_pos):
			if event.is_action_pressed("mouse_right"):
				on = !on
				get_base().values = [on]
				if on:
					get_child(1).text = "ON"
				else:
					get_child(1).text = "OFF"

func is_mouse_inside(mouse_pos):
	return mouse_pos.x >= global_position.x && mouse_pos.x < global_position.x + 128 && mouse_pos.y >= global_position.y && mouse_pos.y < global_position.y + 128
