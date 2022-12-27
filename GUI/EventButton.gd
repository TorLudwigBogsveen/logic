class_name EventButton
extends Button

signal left_pressed
signal right_pressed

func _ready():
	var _err = connect("gui_input", self, "_on_Button_gui_input")

func _on_Button_gui_input(event):
	if event is InputEventMouseButton and !event.pressed:
		match event.button_index:
			BUTTON_LEFT:
				emit_signal("left_pressed")
			BUTTON_RIGHT:
				emit_signal("right_pressed")
