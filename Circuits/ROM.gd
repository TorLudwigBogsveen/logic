extends "res://Circuits/CircuitBase.gd"

var path = null
var data = null

var byte = 0
var bit = 1

var clock = false

func _ready():
	get_base().set_n_inputs(1)
	get_base().set_n_outputs(1)

func run():
	if data == null || path == null:
		return
		
	get_base().values = [(data[byte] & bit) == bit]
	var inputs = get_base().get_input_values()
	if !inputs[0] && !clock:
		clock = true
	
	if inputs[0] && clock:
		clock = false
		bit = bit << 1
		if bit == (1 << 8):
			bit = 1
			byte += 1
		if byte >= data.size():
			byte = 0
	
func save():
	var s = .save()
	s["function"] = "ROM"
	s["path"] = path
	return s

func _input(event):
	if event is InputEventMouse:
		var mouse_pos = get_viewport().get_mouse_position()
		if is_mouse_inside(mouse_pos):
			if event.is_action_pressed("mouse_right"):
				file_menu()

func file_menu():
	var popup = FileDialog.new()
	popup.mode = FileDialog.MODE_OPEN_FILE
	popup.set_access(FileDialog.ACCESS_USERDATA)
	popup.connect("file_selected", self, "file_selected")
	add_child(popup)
	popup.popup_centered(Vector2(640, 480))

func file_selected(file_path):
	path = file_path
	var file = File.new()
	file.open(file_path, File.READ)
	data = file.get_buffer(file.get_len())
	file.close()
