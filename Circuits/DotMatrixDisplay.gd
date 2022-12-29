extends "res://Circuits/CircuitBase.gd"

enum DisplayType {
	WHITE_BLACK,
	GREEN_BLACK,
	RED_BLACK,
	BLUE_BLACK,
	GOLD
}

var type = DisplayType.WHITE_BLACK
var data = null
var new_data = null
var index = 0
var clock: bool = false
var size = Vector2()
var new_size = null

func _ready():
	get_base().set_n_inputs(2)
	set_size(8, 8)
	data = new_data
	size = new_size

func set_size(width, height):
	new_size = Vector2(width, height)
	new_data = PoolColorArray()
	new_data.resize(width * height)
	new_data.fill(Color.black)
	get_base().set_size(Vector2(width*16+16, height*16+16))
	index = 0
	
func set_width(width):
	set_size(max(int(width), 1), size.y)

func set_height(height):
	set_size(size.x, max(int(height), 1))
	
func _draw():
	for y in range(int(size.y)):
		for x in range(int(size.x)):
			#draw_circle(Vector2(x*14+7+9, y*14+7+9), 7, data[x+y*size.x])
			draw_rect(Rect2(x*16+8, y*16+8, 16, 16), data[x+y*size.x])
	pass

func open_menu(popup):
	popup.add_item("Choose Size", 2)

func menu_button_pressed(action):
	if action == 2:
		open_choose_size_menu()

func open_choose_size_menu():
	var popup = Popup.new()
	var mouse = get_viewport().get_mouse_position()
	
	add_child(popup)
	
	popup.connect("popup_hide", self, "remove_child", [popup])
	
	popup.popup_centered(Vector2(0, 0))
	popup.rect_position = Vector2(mouse.x, mouse.y)
	popup.rect_size = Vector2(256, 84)
	
	var width = LineEdit.new()
	width.connect("text_entered", self, "set_width")
	width.connect("text_changed", self, "set_width")
	
	var height = LineEdit.new()
	height.connect("text_entered", self, "set_height")
	height.connect("text_changed", self, "set_height")
	height.rect_position = Vector2(64, 0)
	
	popup.add_child(width)
	popup.add_child(height)
	pass

func run():
	if data == null:
		return
		
	if new_data != null:
		data = new_data
		new_data = null
		size = new_size
		update()
		
	var inputs = get_base().get_input_values()
	if !inputs[0] && !clock:
		clock = true
	
	if inputs[0] && clock:
		update()
		
		clock = false
		
		match type:
			DisplayType.WHITE_BLACK:
				if inputs[1]:
					data[index] = Color.white
				else:
					data[index] = Color.black
			DisplayType.GREEN_BLACK:
				if inputs[1]:
					data[index] = Color.green
				else:
					data[index] = Color.black
			DisplayType.RED_BLACK:
				if inputs[1]:
					data[index] = Color.red
				else:
					data[index] = Color.black
			DisplayType.BLUE_BLACK:
				if inputs[1]:
					data[index] = Color.blue
				else:
					data[index] = Color.black
			DisplayType.GOLD:
				if inputs[1]:
					data[index] = Color.gold
				else:
					data[index] = Color.black
		
		index += 1
		if index >= data.size():
			index = 0
	
func save():
	var s = .save()
	s["function"] = "DMD"
	return s
