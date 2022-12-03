extends VBoxContainer

var node_list = null;

var circuit_scene = load("res://Circuits/FunctionCircuit.tscn")
var ssd_scene = load("res://Circuits/SevenSegmentDisplay.tscn")
var btn_scene = load("res://Circuits/Button.tscn")
var key_scene = load("res://Circuits/Key.tscn")

var CustomFunction = load("res://Util/CustomFunction.gd")
var NandFunction = load("res://Util/NandFunction.gd")
var FunctionInput = load("res://Util/FunctionInput.gd")
var FunctionOutput = load("res://Util/FunctionOutput.gd")

func _ready():
	node_list = get_node(NodePath("/root/Node2D/NodeList"))
	add_custom("NAND")
	add_custom("SSD")
	add_custom("BTN")
	add_custom("KEY")
	
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
	btn.theme = load("World.tres")
	add_child(btn)


func button_pressed(btn):
	if btn.text == "NAND":
		var custom_function = CustomFunction.new()
		custom_function.from_json(
			to_json({
				"name": "NAND",
				"inputs": [
					{"connections": [{"id": 0, "parent": 1}], "id": 0, "parent": 0},
					{"connections": [{"id": 1, "parent": 1}], "id": 1, "parent": 0}
				],
				"outputs": [
					{"connection": {"id": 0, "parent": 1},  "id": 0, "parent": 0}
				],
				"nodes": [
					{
						"function": "NAND",
						"id": 1,
						"inputs": [
							{"connection": {"id": 0, "parent": 0}, "id": 0, "parent": 1},
							{"connection": {"id": 1, "parent": 0}, "id": 1, "parent": 1}
						],
						"outputs": [
							{"connections": [{"id": 0, "parent": 0}], "id": 0, "parent": 1}
						]
					}
				]
			})
		)
		var node = circuit_scene.instance()
		node.set_name(custom_function.name).set_function(custom_function)
		node_list.create(node)
	elif btn.text == "SSD":
		var seven_segment_display = ssd_scene.instance()
		node_list.create(seven_segment_display)
	elif btn.text == "BTN":
		var button = btn_scene.instance()
		node_list.create(button)
	elif btn.text == "KEY":
		var key = key_scene.instance()
		node_list.create(key)
	else:
		var file = File.new()
		file.open("user://nodes/" + btn.text + ".save", File.READ)
		var content = file.get_as_text()
		file.close()
		print(content)
		var custom_function = CustomFunction.new()
		custom_function.from_json(content)
		var node = circuit_scene.instance()
		node.set_name(custom_function.name).set_function(custom_function)
		node_list.create(node)
	pass
