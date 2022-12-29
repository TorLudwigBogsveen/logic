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
	
func open_menu(popup):
	popup.add_item("Choose file", 2)

func menu_button_pressed(action):
	if action == 2:
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
