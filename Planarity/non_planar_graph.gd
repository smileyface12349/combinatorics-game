class_name NonPlanarGraph
extends RearrangeableGraph


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	size = Vector2(600, 600)

func set_graph(new_graph: Graphs.RearrangeableGraphDrawing) -> void:
	graph = new_graph
	queue_redraw()
	
# Detect mouse clicks
func _input(event: InputEvent) -> void:
	# Left mouse button pressed done in base function
	super(event)
	
	# Detect right click
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			graph.right_mouse_clicked()
		else:
			graph.right_mouse_released()
		queue_redraw()
