extends Button

@export var numNodes: SBSliderButton
@export var graphGeneration: SBSpinButton
@export var problemType: SBSpinButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("pressed", go)

func go() -> void:
	# Store settings in global variable
	PlanarSettings.num_nodes = int(numNodes.value)
	PlanarSettings.graph_generation = graphGeneration.selected
	PlanarSettings.problem_types = problemType.selected
	
	# Switch to the new scene
	get_tree().change_scene_to_file("res://Planarity/planarity_level.tscn")
