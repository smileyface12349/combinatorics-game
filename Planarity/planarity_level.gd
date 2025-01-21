extends Node2D

var graph: Graphs.Graph
var planarGraph: Graphs.RearrangeableGraphDrawing
var nonPlanarGraph: Graphs.MinorRearrangeableGraphDrawing

@export var planar: PlanarGraph
@export var nonPlanar: NonPlanarGraph
@export var resetDrawingButton: Button
@export var improveDrawingButton: Button
@export var centerDrawingButton: Button
@export var resetNonPlanarButton: Button
@export var shrinkDrawingButton: Button
@export var nonPlanarTable: NonPlanarTable
@export var planarWinButton: Button
@export var nonPlanarWinButton: Button

var improve_button_held: bool = false
const improve_button_every: float = 0.02
var time_since_last_improve: float = 0

var shrink_button_held: bool = false
const shrink_button_every: float = 0.05
var time_since_last_shrink: float = 0
const shrink_per_second: float = 1.5


func _ready() -> void:
	new_graph()
	resetDrawingButton.pressed.connect(reset_planar_drawing)
	improveDrawingButton.button_down.connect(improve_planar_drawing)
	improveDrawingButton.button_up.connect(stop_improving_drawing)
	centerDrawingButton.pressed.connect(recenter_planar_drawing)
	resetNonPlanarButton.pressed.connect(reset_non_planar)
	shrinkDrawingButton.button_down.connect(start_shrinking)
	shrinkDrawingButton.button_up.connect(stop_shrinking)
	planarWinButton.pressed.connect(new_graph)
	nonPlanarWinButton.pressed.connect(new_graph)
	
func _process(delta: float) -> void:
	if improve_button_held:
		time_since_last_improve += delta
		if time_since_last_improve > improve_button_every:
			planar.graph.improve_spacing()
			planar.queue_redraw()
			time_since_last_improve -= improve_button_every
			
	if shrink_button_held:
		time_since_last_shrink += delta
		if time_since_last_shrink > shrink_button_every:
			planar.graph.shrink_drawing(shrink_per_second * delta)
			planar.queue_redraw()
			time_since_last_shrink -= shrink_button_every
			
	# TODO: Optimise this (don't need to do this every frame!)
	nonPlanarTable.update(nonPlanar.graph.get_edge_count(), nonPlanar.graph.get_vertex_count())
	
func on_planar_win() -> void:
	planarWinButton.visible = true
	
func on_non_planar_win() -> void:
	nonPlanarWinButton.visible = true
	
func new_graph() -> void:
	planarWinButton.visible = false
	nonPlanarWinButton.visible = false
	
	# Generate the graph according to the settings
	if PlanarSettings.problem_types == 1:
		# Planar graphs only
		if PlanarSettings.graph_generation == 1:
			graph = Graphs.Graph.get_random_nearly_non_planar(PlanarSettings.num_nodes)
		else:
			graph = Graphs.Graph.get_random_planar(PlanarSettings.num_nodes, 0.35)
	elif PlanarSettings.problem_types == 2:
		# Non-planar graphs only
		if PlanarSettings.graph_generation == 1:
			graph = Graphs.Graph.get_random_nearly_planar(PlanarSettings.num_nodes)
		else:
			graph = Graphs.Graph.get_random_non_planar(PlanarSettings.num_nodes, 0.35)
	else:
		# Planar and non-planar graphs
		if PlanarSettings.graph_generation == 1:
			if randf() < 0.5:
				graph = Graphs.Graph.get_random_nearly_planar(PlanarSettings.num_nodes)
			else:
				graph = Graphs.Graph.get_random_nearly_non_planar(PlanarSettings.num_nodes)
		else:
			# Note: Default Settings
			graph = Graphs.Graph.get_random_connected(PlanarSettings.num_nodes, 0.35)

	planarGraph = graph.get_drawing_best(true).get_rearrangeable(true)
	planarGraph.on_win = on_planar_win
	planar.set_graph(planarGraph)
	nonPlanarGraph = planarGraph.get_minor_rearrangeable(true, on_non_planar_win)
	nonPlanar.set_graph(nonPlanarGraph)

func reset_planar_drawing() -> void:
	planarGraph = graph.get_drawing_random().get_rearrangeable()
	planarGraph.on_win = on_planar_win
	planar.set_graph(planarGraph)

func reset_non_planar() -> void:
	nonPlanarGraph = planarGraph.get_minor_rearrangeable(true, on_non_planar_win)
	nonPlanar.set_graph(nonPlanarGraph)

func improve_planar_drawing() -> void:
	improve_button_held = true

func stop_improving_drawing() -> void:
	improve_button_held = false
	
func recenter_planar_drawing() -> void:
	planar.graph.recenter_drawing()
	planar.queue_redraw()
	
func start_shrinking() -> void:
	shrink_button_held = true
	
func stop_shrinking() -> void:
	shrink_button_held = false
