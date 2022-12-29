extends "res://Circuits/CircuitBase.gd"

var tick_speed = 1
var ticks: int = 0

func _ready():
	get_base().set_n_outputs(1)

func open_menu(popup):
	popup.add_item("Choose Speed", 2)

func menu_button_pressed(action):
	if action == 2:
		open_speed_selection_menu()

func open_speed_selection_menu():
	var popup = Popup.new()
	var mouse = get_viewport().get_mouse_position()
	
	add_child(popup)
	
	popup.connect("popup_hide", self, "remove_child", [popup])
	
	popup.popup_centered(Vector2(0, 0))
	popup.rect_position = Vector2(mouse.x, mouse.y)
	popup.rect_size = Vector2(256, 84)
	
	var input = LineEdit.new()
	input.connect("text_entered", self, "text_entered")
	input.connect("text_changed", self, "text_entered")
	
	popup.add_child(input)

func text_entered(text):
	tick_speed = int(text)
	tick_speed = max(1, tick_speed)
	get_child(2).text = String(tick_speed)

func save():
	var s = .save()
	s["function"] = "CLK"
	s["tick_speed"] = tick_speed
	return s
	
func run():
	ticks += 1
	if ticks % int(tick_speed) == 0:
		get_base().values = [!get_base().values[0]]
