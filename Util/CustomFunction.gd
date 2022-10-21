class_name CustomFunction

var nodes = []

var inputs = []
var outputs = []

var name = "[Null]"

var input_values = []
var input_nodes = []

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

	
	for _i in range(json.inputs.size()):
		var output = FunctionOutput.new()
		output.parent = self
		outputs.push_back(output)
		
	for _i in range(json.outputs.size()):
		inputs.push_back(FunctionInput.new())
	
	for node in json.nodes:
		for input in node.inputs:
			var this = nodes[input.parent-1]
			var other = null
			if input.connection.parent == 0:
				other = self
			else:
				other = nodes[input.connection.parent-1]
			this.inputs[input.id].connected = other.outputs[input.connection.id]

	for input in json.outputs:
		var other = null
		if input.connection.parent == 0:
			other = self
		else:
			other = nodes[input.connection.parent-1]
		inputs[input.id].connected = other.outputs[input.connection.id]
	pass

func set_inputs(inputs):
	input_nodes = inputs

func set_outputs():
	pass

func run():
	for node in nodes:
		node.run()

func get_output_values():
	var output_values = []
	for input in inputs:
		output_values.push_back(input.get_value())
	return output_values

func get_value(output_node):
	assert(outputs.has(output_node))
	return input_values[outputs.find(output_node)]
