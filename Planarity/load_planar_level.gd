extends Button

@export var numNodes: SBSliderButton
@export var edgeChance: SBSliderButton
@export var graphGeneration: SBSpinButton
@export var problemType: SBSpinButton

var chooseTopicScene: PackedScene = preload("res://ChooseTopic/choose_topic.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("pressed", go)

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