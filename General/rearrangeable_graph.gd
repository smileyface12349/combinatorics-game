class_name RearrangeableGraph
extends Node2D

var graph: Graphs.RearrangeableGraphDrawing
var size: Vector2

@export var font: Font

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

var last_mouse_position: Vector2

# Generates a random graph. You may want to use this to generate new graphs.
func generate_random_graph(vertices: int, edge_chance: float = 0.4) -> void:
	graph = Graphs.Graph \
	  # .get_random_connected(n_vertices, Graphs.Graph.get_edge_chance_from_mst(n_vertices, average_degree)) \
		.get_random_connected(vertices, edge_chance) \
		.get_drawing_best() \
		.get_rearrangeable()
	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position: Vector2 = get_viewport().get_mouse_position() - get_global_position()
	if mouse_position != last_mouse_position:
		last_mouse_position = mouse_position
		graph.mouse_moved(graph.world_to_vertex(mouse_position, size))
		queue_redraw()

# Detect mouse clicks
func _input(event: InputEvent) -> void:
	# Left mouse button pressed
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			graph.left_mouse_clicked()
		else:
			graph.left_mouse_released()
		queue_redraw()

func _draw() -> void:
	var draw_vertex: Callable = func (
		position: Vector2, 
		vertex: int, 
		state: Graphs.RearrangeableVertexState = Graphs.RearrangeableVertexState.Default
	) -> void:
		var colour: Color
		match state:
			Graphs.RearrangeableVertexState.Hover: colour = Color.AQUA
			Graphs.RearrangeableVertexState.Selected: colour = Color.BLUE
			Graphs.RearrangeableVertexState.Contract: colour = Color.ORANGE
			Graphs.RearrangeableVertexState.Highlight: colour = Color.YELLOW
			_: colour = Color.WHITE
		draw_circle(position, 10, colour, true)
		draw_circle(position, 10, Color.BLACK, false)
		draw_string(font, position + Vector2(-5, 5), str(vertex), HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(0, 0, 0))
		
	var draw_edge: Callable = func (end1: Vector2, end2: Vector2, crosses: bool = false) -> void:
		draw_line(end1, end2, Color.RED if crosses else Color.BLACK, 2)
		#draw_line(end1, end2, Color.BLACK, 2)
		
	var draw_edge_crossing: Callable = func (position: Vector2) -> void:
		draw_circle(position, 5, Color.RED, true)
	
	graph.draw_rearrangeable(
		size,
		draw_vertex,
		draw_edge,
		draw_edge_crossing
	)
	
