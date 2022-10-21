extends VBoxContainer

var node_list = null;

var CustomFunction = load("res://Util/CustomFunction.gd")
var NandFunction = load("res://Util/NandFunction.gd")
var FunctionInput = load("res://Util/FunctionInput.gd")
var FunctionOutput = load("res://Util/FunctionOutput.gd")

func _ready():
	node_list = get_node(NodePath("/root/Node2D/NodeList"))
	add_custom("NAND")
	
	var dir = Directory.new()
	if dir.open("user://nodes/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				add_custom(file_name.split(".")[0])
			file_name = dir.get_next()


func _process(_delta):
	pass
	
	
func add_custom(name):
	var btn = Button.new()
	btn.text = name
	btn.connect("pressed", self, "button_pressed", [btn])
	add_child(btn)


func button_pressed(btn):
	if btn.text == "NAND":
		var custom_function = CustomFunction.new()
		custom_function.name = "NAND"
		var nand = NandFunction.new()
		custom_function.nodes.push_back(nand)
		
		var o1 = FunctionOutput.new()
		o1.parent = custom_function
		custom_function.outputs.push_back(o1)
		var o2 = FunctionOutput.new()
		o2.parent = custom_function
		custom_function.outputs.push_back(o2)
		
		var i1 = FunctionInput.new()
		i1.connected = o1
		nand.inputs.push_back(i1)
		var i2 = FunctionInput.new()
		i2.connected = o2
		nand.inputs.push_back(i2)
		
		var o3 = FunctionOutput.new()
		o3.parent = nand
		nand.outputs.push_back(o3)
		
		var i3 = FunctionInput.new()
		i3.connected = o3
		custom_function.inputs.push_back(i3)

		node_list.create(custom_function)
	else:
		var file = File.new()
		file.open("user://nodes/" + btn.text + ".save", File.READ)
		var content = file.get_as_text()
		file.close()
		var custom_function = CustomFunction.new()
		custom_function.from_json(content)
		node_list.create(custom_function)
	pass
