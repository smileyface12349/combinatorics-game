class_name PlanarGraph
extends RearrangeableGraph


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	size = Vector2(600, 600)

func set_graph(new_graph: Graphs.RearrangeableGraphDrawing) -> void:
	graph = new_graph
	queue_redraw()
