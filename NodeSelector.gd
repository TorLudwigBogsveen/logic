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
