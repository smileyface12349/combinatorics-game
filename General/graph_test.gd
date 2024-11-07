extends Node2D

var graph: Graphs.Graph
var drawing: Graphs.GraphDrawing

const n_vertices: int = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#graph = Graphs.Graph.new({
		#0: [1, 4, 3],
		#1: [0, 3],
		#2: [5],
		#3: [1, 5, 0, 4],
		#4: [0, 3],
		#5: [2, 3],
		#6: []
	#})
	graph = Graphs.Graph.get_random_connected(n_vertices)
	
	drawing = graph.get_drawing_best()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		#drawing.improve_spacing()
		graph = Graphs.Graph.get_random_connected(n_vertices)
		drawing = graph.get_drawing_best()
		queue_redraw()
	if Input.is_action_just_pressed("ui_down"):
		drawing.improve_spacing()
		queue_redraw()

func _draw() -> void:
	var draw_vertex: Callable = func (position: Vector2) -> void:
		draw_circle(position, 5, Color.BLACK)
		
	var draw_edge: Callable = func (end1: Vector2, end2: Vector2) -> void:
		draw_line(end1, end2, Color.BLACK, 2)
	
	drawing.draw(
		500,
		500,
		draw_vertex,
		draw_edge
	)
