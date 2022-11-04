extends Node2D

var radius = 10;
var selected = false

func _input(event):
	if event is InputEventMouse:
		if event.is_action_pressed("mouse_left"):
			if global_position.distance_to(event.position) <= radius:
				selected = true
				print(event)
		elif event.is_action_released("mouse_left"):
			if global_position.distance_to(event.position) <= radius:
				selected = false
				print(event)
		elif event is InputEventMouseMotion:
			if selected:
				set_global_position(event.position)
				
func _process(_delta):
	print(position)
	update()

func _draw():
	draw_line(Vector2.ZERO, -position, Color.beige)
	draw_circle(Vector2(0, 0), radius, Color.beige)

func _ready():
	pass 
