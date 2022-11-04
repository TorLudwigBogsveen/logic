class_name CustomFunction

var NandFunction = load("res://Util/NandFunction.gd")

var nodes = []

var inputs = []
var outputs = []

var name = "[Null]"

var input_values = []

var input_node = IOFunction.new(self)
var output_node = IOFunction.new(self)

func from_json(json_data):
	var json = JSON.parse(json_data).result
	name = json.name
	
	nodes.resize(json.nodes.size())
	for node in json.nodes:
		if node.function == "NAND":
			var nand = NandFunction.new()
			nand.set_inputs([FunctionInput.new(), FunctionInput.new()])
			var output = FunctionOutput.new()
			output.parent = nand
			nand.set_outputs([output])
			nodes[node.id-1] = nand
		else:
			var file = File.new()
			file.open("user://nodes/" + node.function + ".save", File.READ)
			var content = file.get_as_text()
			file.close()
			var n = get_script().new()
			n.from_json(content)
			nodes[node.id-1] = n
	
	input_values.resize(json.inputs.size())
	input_values.fill(false)
	
	input_node.set_n_io(json.inputs.size())
	for input in input_node.inputs:
		inputs.push_back(input)
	
	output_node.set_n_io(json.outputs.size())
	for output in output_node.outputs:
		outputs.push_back(output)
	
	for node in json.nodes:
		for input in node.inputs:
			var this = nodes[input.parent-1]
			if input.connection.parent == 0:
				this.inputs[input.id].connected = input_node.outputs[input.connection.id]
			else:
				var other = nodes[input.connection.parent-1]
				this.inputs[input.id].connected = other.outputs[input.connection.id]
				
	for output in json.outputs:
		output_node.inputs[output.id].connected = nodes[output.connection.parent-1].outputs[output.connection.id]

func reset():
	for node in nodes:
		node.reset()

func run():
	for node in nodes:
		node.run()

func get_output_values():
	var output_values = []
	for output in outputs:
		output_values.push_back(output.get_value())
	return output_values

func get_value(output):
	if input_node.outputs.has(output):
		return input_values[input_node.outputs.find(output)]
	else:
		return false
