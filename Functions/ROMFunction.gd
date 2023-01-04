class_name ROMFunction

var inputs = []
var outputs = []
var old_value = false
var value = false

var path = null
var data = null

var byte = 0
var bit = 1

var clock = false

func run():
	if data == null || path == null:
		return
		
	value = (data[byte] & bit) == bit
	if !inputs[0].get_value() && !clock:
		clock = true
	
	if inputs[0].get_value() && clock:
		clock = false
		bit = bit << 1
		if bit == (1 << 8):
			bit = 1
			byte += 1
		if byte >= data.size():
			byte = 0

func file_selected(file_path):
	path = file_path
	var file = File.new()
	file.open(file_path, File.READ)
	data = file.get_buffer(file.get_len())
	file.close()

func reset():
	old_value = value

func set_inputs(n_inputs):
	inputs = n_inputs
	
func set_outputs(n_outputs):
	outputs = n_outputs

func get_value(output_node):
	assert(outputs.has(output_node))
	return old_value
