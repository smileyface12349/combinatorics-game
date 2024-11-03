extends Node2D

var graph: Graphs.Graph

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	graph = Graphs.Graph.new(5)
	
	graph.vertices[0].neighbours.append(graph.vertices[2])
	graph.vertices[1].neighbours.append(graph.vertices[3])
	graph.vertices[0].neighbours.append(graph.vertices[1])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	var draw_vertex: Callable = func (position: Vector2) -> void:
		draw_circle(position, 5, Color.BLACK)
		
	var draw_edge: Callable = func (end1: Vector2, end2: Vector2) -> void:
		draw_line(end1, end2, Color.BLACK, 2)
	
	graph.draw(
		100,
		100,
		draw_vertex,
		draw_edge
	)
