extends RearrangeableGraph

const n_vertices: int = 8
const average_degree: int = 7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = Vector2(500, 500)
	generate_random_graph(n_vertices)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("ui_accept"):
		generate_random_graph(n_vertices)
		queue_redraw()
