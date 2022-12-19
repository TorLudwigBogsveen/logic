extends "res://Circuits/CircuitBase.gd"

var selected = false
var tick_speed = 1
var ticks: int = 0

func _ready():
	get_base().set_outputs([0])

func _input(event):
	if event is InputEventMouseButton:
		if selected && event.button_index == BUTTON_WHEEL_UP:
			tick_speed += 0.5
			get_child(2).text = String(tick_speed)
		if selected && event.button_index == BUTTON_WHEEL_DOWN:
			tick_speed -= 0.5
			tick_speed = max(1, tick_speed)
			get_child(2).text = String(tick_speed)
			
	if event is InputEventMouse:
		if event.is_action_pressed("mouse"):
			selected = false
		
		var mouse_pos = get_viewport().get_mouse_position()
		if is_mouse_inside(mouse_pos):
			if event.is_action_pressed("mouse_right"):
				selected = true
func save():
	var s = .save()
	s["function"] = "CLK"
	s["tick_speed"] = tick_speed
	return s
	
func run():
	ticks += 1
	if ticks % int(tick_speed) == 0:
		get_base().values = [!get_base().values[0]]
