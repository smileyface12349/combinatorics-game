extends Node

@export var generateProblemButton: Button

var chooseTopicScene: PackedScene = preload("res://ChooseTopic/choose_topic.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generateProblemButton.connect("pressed", generate_problem)

func _input(event: InputEvent) -> void:
	# ESC to go back to menu
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_packed(chooseTopicScene)

func generate_problem() -> void:
	# Choose two random problems
	var problem1: CatalanProblem = CatalanProblems.new().PROBLEMS.pick_random()
	var problem2: CatalanProblem = CatalanProblems.new().PROBLEMS.pick_random()

	# Make sure they're not the same problem - that would be boring wouldn't it!
	while problem1.description == problem2.description:
		problem2 = CatalanProblems.new().PROBLEMS.pick_random()

	# Combine these into one level and assign it
	BijectionSettings.current_level = BijectionLevel.from_catalan_problems(problem1, problem2)

	# Change to the bijection scene
	get_tree().change_scene_to_file("res://Bijections/bijection_level.tscn")