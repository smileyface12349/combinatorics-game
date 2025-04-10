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
@export var skipButton: Button
@export var successSound: AudioStreamPlayer

var improve_button_held: bool = false
const improve_button_every: float = 0.02
var time_since_last_improve: float = 0

var shrink_button_held: bool = false
const shrink_button_every: float = 0.05
var time_since_last_shrink: float = 0
const shrink_per_second: float = 1.5

var win_dialogue: DialogueResource = preload("res://Dialogue/planar_win.dialogue")


func _ready() -> void:
	new_graph()
	resetDrawingButton.pressed.connect(reset_planar_drawing)
	improveDrawingButton.button_down.connect(improve_planar_drawing)
	improveDrawingButton.button_up.connect(stop_improving_drawing)
	centerDrawingButton.pressed.connect(recenter_planar_drawing)
	resetNonPlanarButton.pressed.connect(reset_non_planar)
	shrinkDrawingButton.button_down.connect(start_shrinking)
	shrinkDrawingButton.button_up.connect(stop_shrinking)
	planarWinButton.pressed.connect(planar_win_new_graph)
	nonPlanarWinButton.pressed.connect(non_planar_win_new_graph)
	skipButton.pressed.connect(new_graph)
	
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
	
func _input(event: InputEvent) -> void:
	# ESC to go back to menu
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Planarity/planar_settings.tscn")

func on_planar_win() -> void:
	planarWinButton.visible = true
	successSound.play()
	
func on_non_planar_win() -> void:
	nonPlanarWinButton.visible = true
	successSound.play()

func planar_win_new_graph() -> void:
	if PlanarSettings.is_challenge:
		SaveData.planar_challenge_solved[0] += 1
		SaveData.write()
		check_topic_complete()
	new_graph()

func non_planar_win_new_graph() -> void:
	if PlanarSettings.is_challenge:
		SaveData.planar_challenge_solved[1] += 1
		SaveData.write()
		check_topic_complete()
	new_graph()

func check_topic_complete() -> void:
	if SaveData.planar_challenge_solved[0] >= 5 and SaveData.planar_challenge_solved[1] >= 5:
		SaveData.topics_done.append("planarity")
		SaveData.write()
		get_tree().change_scene_to_file("res://ChooseTopic/choose_topic.tscn")
		DialogueManager.show_dialogue_balloon(win_dialogue)
	
func new_graph() -> void:
	planarWinButton.visible = false
	nonPlanarWinButton.visible = false
	
	# Generate the graph according to the settings
	# if PlanarSettings.problem_types == 1:
	# 	# Planar graphs only
	# 	if PlanarSettings.graph_generation == 1:
	# 		graph = Graphs.Graph.get_random_nearly_non_planar(PlanarSettings.num_nodes)
	# 	else:
	# 		graph = Graphs.Graph.get_random_planar(PlanarSettings.num_nodes, 0.33)
	# elif PlanarSettings.problem_types == 2:
	# 	# Non-planar graphs only
	# 	if PlanarSettings.graph_generation == 1:
	# 		graph = Graphs.Graph.get_random_nearly_planar(PlanarSettings.num_nodes)
	# 	else:
	# 		graph = Graphs.Graph.get_random_non_planar(PlanarSettings.num_nodes, 0.33)
	# else:
	# 	# Planar and non-planar graphs
	# 	if PlanarSettings.graph_generation == 1:
	# 		if randf() < 0.5:
	# 			graph = Graphs.Graph.get_random_nearly_planar(PlanarSettings.num_nodes)
	# 		else:
	# 			graph = Graphs.Graph.get_random_nearly_non_planar(PlanarSettings.num_nodes)
	# 	else:
	# 		# Note: Default Settings
	# 		graph = Graphs.Graph.get_random_connected(PlanarSettings.num_nodes, 0.33)
	if not PlanarSettings.custom_graph: 
		graph = Graphs.Graph.get_random_connected(PlanarSettings.num_nodes, PlanarSettings.edge_chance)
	else:
		graph = PlanarSettings.custom_graph
		PlanarSettings.custom_graph = null

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
