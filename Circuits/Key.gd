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

func open_menu(popup):
	popup.add_item("Choose Key", 2)

func menu_button_pressed(action):
	if action == 2:
		selected = true


func _input(event):
	if event is InputEventKey:
		if selected && event.pressed:
			selected = false
			set_key(event.scancode)
		elif event.pressed && event.scancode == key:
			get_base().values = [true]
		elif !event.pressed && event.scancode == key:
			get_base().values = [false]
