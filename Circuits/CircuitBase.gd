extends Node2D

var base = null

func save():
	return get_base().save()

func get_base():
	if base == null:
		base = get_child(0)
	return base

func set_id(id):
	get_base().id = id

func select_node():
	get_parent().selected_node = self

func unselect_node():
	get_parent().selected_node = null

func clicked_input(input, btn):
	get_parent().clicked_input(input, btn)

func clicked_output(output, btn):
	get_parent().clicked_output(output, btn)
	
func reset():
	base.reset()

func run():
	pass
