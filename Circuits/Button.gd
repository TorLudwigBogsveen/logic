extends "res://Circuits/CircuitBase.gd"

var on = false;

func _ready():
	get_base().set_n_outputs(1)

func open_menu(popup):
	popup.add_item("Flip ON/OFF", 2)

func menu_button_pressed(action):
	if action == 2:
		on = !on
		get_base().values = [on]
		if on:
			get_child(1).text = "ON"
		else:
			get_child(1).text = "OFF"
