extends Node2D
class_name ColouringGraph

var graph: Graphs.ColourableGraphDrawing
var size: Vector2
@export var font: Font
var on_colouring_changed: Callable
var last_mouse_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = Vector2(1000, 750)

func set_graph(new_graph: Graphs.ColourableGraphDrawing) -> void:
	graph = new_graph
	queue_redraw()

func set_callback(callback: Callable) -> void:
	self.on_colouring_changed = callback

func set_upper_bound(bound: int) -> void:
	graph.set_colouring_upper_bound(bound)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position: Vector2 = get_viewport().get_mouse_position() - get_global_position()
	if mouse_position != last_mouse_position:
		last_mouse_position = mouse_position
		graph.mouse_moved(graph.world_to_vertex(mouse_position, size))
		queue_redraw()

# Detect mouse clicks
func _input(event: InputEvent) -> void:
	# Left mouse button pressed done in base function
	# Left mouse button pressed
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			graph.left_mouse_clicked()
		else:
			graph.left_mouse_released()
		queue_redraw()
	
	# Detect right click
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			graph.right_mouse_clicked()
		else:
			graph.right_mouse_released()
		self.on_colouring_changed.call()
		queue_redraw()

func _draw() -> void:
	var draw_vertex: Callable = func (
		position: Vector2, 
		vertex: int, 
		state: Graphs.RearrangeableVertexState = Graphs.RearrangeableVertexState.Default,
		hover: bool = false
	) -> void:
		var colour: Color
		match state:
			Graphs.RearrangeableVertexState.Colour1: colour = Color.DARK_ORCHID
			Graphs.RearrangeableVertexState.Colour2: colour = Color.CORNFLOWER_BLUE
			Graphs.RearrangeableVertexState.Colour3: colour = Color.MEDIUM_SEA_GREEN
			Graphs.RearrangeableVertexState.Colour4: colour = Color.GOLD
			Graphs.RearrangeableVertexState.Colour5: colour = Color.RED
			Graphs.RearrangeableVertexState.Colour6: colour = Color.HOT_PINK
			Graphs.RearrangeableVertexState.Colour7: colour = Color.DARK_ORANGE 
			Graphs.RearrangeableVertexState.Colour8: colour = Color.LIGHT_SEA_GREEN
			Graphs.RearrangeableVertexState.Colour9: colour = Color.YELLOW_GREEN

			# Note: Colours beyond this point aren't really used, so don't worry about them as much
			Graphs.RearrangeableVertexState.Colour10: colour = Color.WEB_MAROON
			Graphs.RearrangeableVertexState.Colour11: colour = Color.SADDLE_BROWN
			Graphs.RearrangeableVertexState.Colour12: colour = Color.SPRING_GREEN
			Graphs.RearrangeableVertexState.Colour13: colour = Color.DARK_MAGENTA
			Graphs.RearrangeableVertexState.Colour14: colour = Color.OLIVE
			Graphs.RearrangeableVertexState.Colour15: colour = Color.GOLDENROD
			Graphs.RearrangeableVertexState.Colour16: colour = Color.SALMON
			_: colour = Color.WHITE
		if hover:
			var light_amount: float = 0.3
			colour = Color(lerp(colour.r, 1.0, light_amount), lerp(colour.g, 1.0, light_amount), lerp(colour.b, 1.0, light_amount), ) # make it lighter when hovering
		draw_circle(position, Graphs.vertex_radius, colour, true)
		draw_circle(position, Graphs.vertex_radius, Color.BLACK, false)
		draw_string(font, position + Vector2(-6, 7), str(vertex), HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color(0, 0, 0))
		
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
	
