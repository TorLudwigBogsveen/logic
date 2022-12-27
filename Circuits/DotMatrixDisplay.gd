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
var index = 0
var clock: bool = false
var size = Vector2()

func _ready():
	get_base().set_n_inputs(2)
	set_size(8, 8)

func set_size(width, height):
	size = Vector2(width, height)
	data = PoolColorArray()
	data.resize(width * height)
	data.fill(Color.black)
	
func _draw():
	for y in range(int(size.y)):
		for x in range(int(size.x)):
			#draw_circle(Vector2(x*14+7+9, y*14+7+9), 7, data[x+y*size.x])
			draw_rect(Rect2(x*14+7+2, y*14+7+2, 12, 12), data[x+y*size.x])
	pass

func run():
	if data == null:
		return
		
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
