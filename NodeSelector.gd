extends VBoxContainer

var node_list = null;

enum RightClickMenuButton {
	EDIT = 0,
	RENAME = 1,
	DELETE = 2
}

func _ready():
	node_list = get_node(NodePath("/root/World/NodeList"))
	add_custom("NAND")
	add_custom("SSD")
	add_custom("BTN")
	add_custom("KEY")
	add_custom("CLOCK")
	add_custom("ROM")
	add_custom("DMD")
	
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
	for child in get_children():
		if child.text == name:
			return
	
	var btn = EventButton.new()
	btn.text = name
	btn.connect("left_pressed", self, "button_left_pressed", [btn])
	btn.connect("right_pressed", self, "button_right_pressed", [btn])
	btn.theme = load("World.tres")
	add_child(btn)

func button_right_pressed(btn):
	var popup = PopupMenu.new()
	var mouse = get_viewport().get_mouse_position()
	
	add_child(popup)
	
	popup.add_item("Edit", RightClickMenuButton.EDIT)
	popup.add_item("Rename", RightClickMenuButton.RENAME)
	popup.add_item("Delete", RightClickMenuButton.DELETE)
	
	popup.connect("popup_hide", self, "remove_child", [popup])
	popup.connect("id_pressed", self, "menu_button_pressed", [btn])
	
	popup.popup_centered(Vector2(0, 0))
	popup.rect_position = Vector2(mouse.x, mouse.y)

func menu_button_pressed(action, btn):
	match btn.text:
		"NAND", "CLOCK", "BTN", "KEY", "SSD", "ROM", "DMD": return
		
	match action:
		RightClickMenuButton.EDIT:
			edit_node(btn)
		RightClickMenuButton.RENAME:
			rename_node(btn)
		RightClickMenuButton.DELETE:
			delete_node(btn)

func edit_node(btn):
	node_list.load_custom(btn.text)

func rename_node(btn):
	var popup = PopupPanel.new()
	var mouse = get_viewport().get_mouse_position()
	
	add_child(popup)
	
	var text = LineEdit.new()
	text.connect("text_entered", self, "text_entered", [popup, btn])
	
	popup.add_child(text)
	popup.connect("popup_hide", self, "text_popup_closed", [popup, text, btn])
	popup.popup_centered()
	popup.rect_position = Vector2(mouse.x, mouse.y)

func text_popup_closed(text, popup, btn):
	if !get_children().has(popup):
		return
	remove_child(popup)
	if text.text != "":
		text_entered(text.text, popup, btn)

func text_entered(text, popup, btn):
	if !get_children().has(popup):
		return
	remove_child(popup)
	
	node_list.rename_nodes(btn.text, text)
	
	var file = File.new()
	file.open("user://nodes/" + btn.text + ".save", File.READ)
	var content = file.get_as_text()
	file.close()
	
	var dir = Directory.new()
	dir.open("user://nodes/")
	dir.remove(btn.text + ".save")
	
	btn.text = text
	
	var json = JSON.parse(content).result
	json.name = text
	file.open("user://nodes/" + btn.text + ".save", File.WRITE)
	file.store_line(to_json(json))
	file.close()

func delete_node(btn):
	remove_child(btn)
	var dir = Directory.new()
	dir.open("user://nodes/")
	dir.remove(btn.text + ".save")

func button_left_pressed(btn):
	var node = node_list.spawn_node(btn.text)
	node_list.create(node)
