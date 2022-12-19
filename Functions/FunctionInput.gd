class_name FunctionInput

var connected = null

func get_value():
	if connected != null:
		return connected.get_value()
	else:
		return false
