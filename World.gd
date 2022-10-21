extends Node2D

var node_name = null

func _ready():
	pass 


func _on_SaveButton_pressed():
	if node_name != null && node_name != "":
		get_node("NodeList").save_custom(node_name)
		get_node("Control/Panel/NodeSelector").add_custom(node_name)


func _on_DeleteButton_pressed():
	get_node("NodeList").delete()


func _on_NInputsField_text_changed(new_text):
	if new_text.is_valid_integer():
		var n_inputs = int(new_text)
		get_node("NodeList").set_n_inputs(n_inputs)


func _on_NOutputsField_text_changed(new_text):
	if new_text.is_valid_integer():
		var n_outputs = int(new_text)
		get_node("NodeList").set_n_outputs(n_outputs)


func _on_NameField_text_changed(new_text):
	node_name = new_text
