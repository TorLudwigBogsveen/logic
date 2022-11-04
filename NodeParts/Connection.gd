extends Node2D

var connection_point = load("res://NodeParts/ConnectionPoint.tscn")
var connection_controll = load("res://NodeParts/ConnectionControll.tscn")

var curve = Curve2D.new();

var p0_vertex
var p0_out

var p1_in
var p1_vertex

var p2_in
var p2_vertex
	
# Called when the node enters the scene tree for the first time.
func _ready():
	p0_vertex = connection_point.instance()
	p0_out = connection_controll.instance()

	p1_in = connection_controll.instance()
	p1_vertex = connection_point.instance()
	
	p2_in = connection_controll.instance()
	p2_vertex = connection_point.instance()
	

	p0_vertex.set_position(Vector2(100, 100))
	add_child(p0_vertex)
	
	p0_out.set_position(Vector2(50, 50))
	p0_vertex.add_child(p0_out)
	

	p1_in.set_position(Vector2(50, 50))
	p1_vertex.add_child(p1_in)

	p1_vertex.set_position(Vector2(200, 300))
	add_child(p1_vertex)
	
	p2_in.set_position(Vector2(50, 50))
	p2_vertex.add_child(p2_in)

	p2_vertex.set_position(Vector2(300, 400))
	add_child(p2_vertex)
	
	pass # Replace with function body.
	
func _process(_delta):
	curve.clear_points()
	curve.add_point(p0_vertex.global_position, Vector2.ZERO, p0_out.position);
	curve.add_point(p1_vertex.global_position, p1_in.position, Vector2.ZERO);
	curve.add_point(p2_vertex.global_position, p2_in.position, Vector2.ZERO);
	update()
	
func _draw():
	draw_polyline(curve.tessellate(10, 1), Color.brown, 8.0)
