extends "res://Circuits/CircuitBase.gd"

func _ready():
	get_base().set_n_inputs(8)
	pass 
	
func run():
	var input_values = get_base().get_input_values()
			
	for i in range(input_values.size()):
		if input_values[i]:
			get_child(i+1).color = Color.red
		else:
			get_child(i+1).color = Color.black
