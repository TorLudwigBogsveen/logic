extends Node2D

var radius = 10;
var selected = false

func _input(event):
	if event is InputEventMouse:
		if event.is_action_pressed("mouse_left"):
			if global_position.distance_to(event.position) <= radius:
				selected = true
		elif event.is_action_released("mouse_left"):
			if global_position.distance_to(event.position) <= radius:
				selected = false
		elif event is InputEventMouseMotion:
			if selected:
				set_position(event.position)
	

func _draw():
	draw_circle(Vector2(0, 0), radius, Color.beige)

func _ready():
	pass 
