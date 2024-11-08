extends Node2D

var graph: Graphs.Graph
var drawing: Graphs.RearrangeableGraphDrawing

const n_vertices: int = 8
const size: Vector2 = Vector2(500, 500)

@export var font: Font

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
	drawing = graph.get_drawing_best().get_rearrangeable()

var last_mouse_position: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		#drawing.improve_spacing()
		graph = Graphs.Graph.get_random_connected(n_vertices)
		drawing = graph.get_drawing_best().get_rearrangeable()
		queue_redraw()
	#if Input.is_action_just_pressed("ui_down"):
		#drawing.improve_spacing()
		#queue_redraw()
	#if Input.is_action_pressed("ui_up"):
		#drawing.improve_spacing()
		#queue_redraw()
		
	var mouse_position: Vector2 = get_viewport().get_mouse_position() - get_global_position()
	if mouse_position != last_mouse_position:
		last_mouse_position = mouse_position
		drawing.mouse_moved(drawing.world_to_vertex(mouse_position, size))
		queue_redraw()

# Detect mouse clicks
func _input(event: InputEvent) -> void:
	# Left mouse button pressed
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			drawing.left_mouse_clicked()
		else:
			drawing.left_mouse_released()
		queue_redraw()

func _draw() -> void:
	var draw_vertex: Callable = func (
		position: Vector2, 
		vertex: int, 
		state: Graphs.RearrangeableVertexState = Graphs.RearrangeableVertexState.Default
	) -> void:
		var colour: Color
		if state == Graphs.RearrangeableVertexState.Hover:
			colour = Color.AQUA
		elif state == Graphs.RearrangeableVertexState.Selected:
			colour = Color.BLUE
		else:
			colour = Color.WHITE
		draw_circle(position, 10, colour, true)
		draw_circle(position, 10, Color.BLACK, false)
		draw_string(font, position + Vector2(-5, 5), str(vertex), HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(0, 0, 0))
		
	var draw_edge: Callable = func (end1: Vector2, end2: Vector2, crosses: bool = false) -> void:
		draw_line(end1, end2, Color.RED if crosses else Color.BLACK, 2)
	
	drawing.draw(
		size,
		draw_vertex,
		draw_edge,
		true
	)
