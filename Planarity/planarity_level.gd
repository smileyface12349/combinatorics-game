extends Node2D

var graph: Graphs.Graph
var planarGraph: Graphs.RearrangeableGraphDrawing
var nonPlanarGraph: Graphs.MinorRearrangeableGraphDrawing

@export var planar: PlanarGraph
@export var nonPlanar: NonPlanarGraph
@export var resetDrawingButton: Button
@export var improveDrawingButton: Button
@export var centerDrawingButton: Button

var improve_button_held: bool = false
var improve_button_every: float = 0.02
var time_since_last_improve: float = 0

func _ready() -> void:
	new_graph()
	resetDrawingButton.pressed.connect(reset_planar_drawing)
	improveDrawingButton.button_down.connect(improve_planar_drawing)
	improveDrawingButton.button_up.connect(stop_improving_drawing)
	centerDrawingButton.pressed.connect(recenter_planar_drawing)
	
func _process(delta: float) -> void:
	if improve_button_held:
		time_since_last_improve += delta
		if time_since_last_improve > improve_button_every:
			planar.graph.improve_spacing()
			planar.queue_redraw()
			time_since_last_improve -= improve_button_every
	
func new_graph() -> void:
	graph = Graphs.Graph.get_random_connected(8, 0.4)
	planarGraph = graph.get_drawing_best(true).get_rearrangeable(true)
	planar.set_graph(planarGraph)
	nonPlanarGraph = planarGraph.get_minor_rearrangeable(true)
	nonPlanar.set_graph(nonPlanarGraph)

func reset_planar_drawing() -> void:
	planarGraph = graph.get_drawing_random().get_rearrangeable()
	planar.set_graph(planarGraph)

func improve_planar_drawing() -> void:
	improve_button_held = true

func stop_improving_drawing() -> void:
	improve_button_held = false
	
func recenter_planar_drawing() -> void:
	planar.graph.recenter_drawing()
	planar.queue_redraw()
