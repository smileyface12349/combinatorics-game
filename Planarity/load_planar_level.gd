extends Button

@export var numNodes: SBSliderButton
@export var edgeChance: SBSliderButton
@export var graphGeneration: SBSpinButton
@export var problemType: SBSpinButton

var chooseTopicScene: PackedScene = preload("res://ChooseTopic/choose_topic.tscn")
var track: AudioStream = preload("res://Music/Robobozo.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("pressed", go)
	MusicPlayer.change_track(track)

func go() -> void:
	# Store settings in global variable
	PlanarSettings.num_nodes = int(numNodes.value)
	PlanarSettings.edge_chance = float(edgeChance.value)
	PlanarSettings.graph_generation = graphGeneration.selected
	PlanarSettings.problem_types = problemType.selected
	
	# Switch to the new scene
	get_tree().change_scene_to_file("res://Planarity/planarity_level.tscn")

func _input(event: InputEvent) -> void:
	# ESC to go back to menu
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_packed(chooseTopicScene)

	# Custom demo graphs
	if Input.is_action_just_pressed("num_1"):
		PlanarSettings.custom_graph = Graphs.Graph.new({ 0: [1, 3, 7, 2, 4, 6], 1: [0, 2], 2: [1, 4, 6, 0, 5], 3: [0, 4, 7], 4: [2, 5, 0, 3, 7], 5: [4, 2, 7], 6: [2, 0, 7], 7: [0, 3, 4, 5, 6] })
		get_tree().change_scene_to_file("res://Planarity/planarity_level.tscn")
