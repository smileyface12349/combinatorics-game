extends Node

var graph: Graphs.ColourableGraphDrawing

@export var graphNode: ColouringGraph
@export var coloursUsedDisplay: RichTextLabel
@export var newGraphButton: Button

func new_graph() -> void:
	graph = Graphs.Graph.get_random_connected(PlanarSettings.num_nodes, PlanarSettings.edge_chance).get_drawing_best().get_rearrangeable().get_colourable()
	graphNode.set_graph(graph)
	graphNode.set_callback(on_colouring_changed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_graph()
	newGraphButton.connect("pressed", new_graph)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_colouring_changed() -> void:
	if graphNode.graph.is_valid_colouring():
		var colours_used: int = graphNode.graph.get_colours_used()
		coloursUsedDisplay.text = "[center]Colours Used: " + str(colours_used)
	else:
		coloursUsedDisplay.text = "[center][color=red]Colouring Not Valid"

func _input(event: InputEvent) -> void:
	# ESC to go back to menu
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Colouring/colouring_settings.tscn")