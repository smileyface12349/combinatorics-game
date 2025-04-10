extends Node

var graph: Graphs.ColourableGraphDrawing

@export var graphNode: ColouringGraph
@export var coloursUsedDisplay: RichTextLabel
@export var newGraphButton: Button
@export var skipGraphButton: Button
@export var exitButton: Button

@export var greedyBound: RichTextLabel
@export var brookesBound: RichTextLabel
@export var planarBound: RichTextLabel
@export var cliqueBound: RichTextLabel
@export var bestBoundsDisplay: RichTextLabel

var newGraphStylebox: StyleBoxFlat

var greedy_upper_bound: int
var brookes_upper_bound: int
var planar_upper_bound: int
var clique_lower_bound: int

var best_lower_bound: int
var best_upper_bound: int

var win_dialogue: DialogueResource = preload("res://Dialogue/colouring_win.dialogue")

func new_graph() -> void:
	# Generate the new graph
	var graphNoDrawing: Graphs.Graph
	if PlanarSettings.custom_graph == null:
		graphNoDrawing = Graphs.Graph.get_random_connected(PlanarSettings.num_nodes, PlanarSettings.edge_chance)
	else:
		graphNoDrawing = PlanarSettings.custom_graph
		PlanarSettings.custom_graph = null
		
	graph = graphNoDrawing.get_drawing_best().get_rearrangeable().get_colourable()
	graphNode.set_graph(graph)
	graphNode.set_callback(on_colouring_changed)

	# Obtain bounds
	greedy_upper_bound = graph.get_max_degree() + 1
	brookes_upper_bound = graph.get_max_degree() # TODO: Might be worth handling the unlikely edge cases here
	if graphNode.graph.is_drawing_planar():
		planar_upper_bound = 4
	else:
		planar_upper_bound = 1000
	clique_lower_bound = graph.get_max_clique()

	# Set the text
	greedyBound.text = "[right]χ(G) ≤ " + str(greedy_upper_bound)
	brookesBound.text = "[right]χ(G) ≤ " + str(brookes_upper_bound)
	if planar_upper_bound < 10:
		planarBound.text = "[right]χ(G) ≤ " + str(planar_upper_bound)
	else:
		planarBound.text = "[right]Not Planar"
	cliqueBound.text = "[right]χ(G) ≥ " + str(clique_lower_bound)

	# Get the best bounds and update the text
	update_best_bounds()

	# Reset anything that needs resetting
	newGraphButton.visible = false
	skipGraphButton.visible = true
	on_colouring_changed()

func on_win_press() -> void:
	if PlanarSettings.is_challenge and graphNode.graph.is_valid_colouring():
		SaveData.colouring_challenge_solved += 1
		SaveData.write()
		check_topic_complete()
	new_graph()

func check_topic_complete() -> void:
	if SaveData.colouring_challenge_solved >= 10:
		SaveData.topics_done.append("colouring")
		SaveData.write()
		get_tree().change_scene_to_file("res://ChooseTopic/choose_topic.tscn")
		DialogueManager.show_dialogue_balloon(win_dialogue)

func _ready() -> void:
	new_graph()
	newGraphButton.connect("pressed", on_win_press)
	skipGraphButton.connect("pressed", new_graph)
	exitButton.connect("pressed", exit)

func update_best_bounds() -> void:
	best_lower_bound = clique_lower_bound
	best_upper_bound = min(greedy_upper_bound, brookes_upper_bound, planar_upper_bound)
	bestBoundsDisplay.text = "[center]" + str(best_lower_bound) + " ≤ χ(G) ≤ " + str(best_upper_bound)
	graphNode.set_upper_bound(best_upper_bound)


func _process(delta: float) -> void:
	# If they find a planar drawing, permanently set the upper bound to 4
	if planar_upper_bound > 10:
		if graphNode.graph.is_drawing_planar():
			planar_upper_bound = 4
			planarBound.text = "[right]χ(G) ≤ " + str(planar_upper_bound)
			update_best_bounds()

func on_colouring_changed() -> void:
	if graphNode.graph.is_valid_colouring():
		var colours_used: int = graphNode.graph.get_colours_used()
		coloursUsedDisplay.text = "[center]Colours Used: " + str(colours_used)
		newGraphButton.visible = true
		skipGraphButton.visible = false
	else:
		coloursUsedDisplay.text = "[center][color=red]Colouring Not Valid"
		newGraphButton.visible = false
		skipGraphButton.visible = true

func _input(event: InputEvent) -> void:
	# ESC to go back to menu
	if Input.is_action_just_pressed("ui_cancel"):
		exit()

func exit() -> void:
	get_tree().change_scene_to_file("res://Colouring/colouring_settings.tscn")