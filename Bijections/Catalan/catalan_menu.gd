extends Node

@export var generateProblemButton: Button
@export var solvedProblemsDisplay: RichTextLabel
@export var exitButton: Button

var chooseTopicScene: PackedScene = preload("res://ChooseTopic/choose_topic.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exitButton.pressed.connect(exit)
	generateProblemButton.connect("pressed", generate_problem)
	if SaveData.catalan_problems_solved.is_empty():
		solvedProblemsDisplay.text = "[center]No problems solved.\n"
	else:
		solvedProblemsDisplay.text = "[center][b]Solved Problems[/b]:\n"
		for solved_problem: Array in SaveData.catalan_problems_solved:
			solvedProblemsDisplay.text += CatalanProblems.new().PROBLEMS[solved_problem[0]].title + " with " + CatalanProblems.new().PROBLEMS[solved_problem[0]].title + "\n"
	solvedProblemsDisplay.text += "\nSolve 5 problems to re-build the hut."


func _input(event: InputEvent) -> void:
	# ESC to go back to menu
	if Input.is_action_just_pressed("ui_cancel"):
		exit()

	# Demo problems
	if Input.is_action_just_pressed("num_1"):
		BijectionSettings.current_level = BijectionLevel.from_catalan_problems(CatalanBinaryTrees.new(), CatalanMotzkinPathsColoured.new())
		get_tree().change_scene_to_file("res://Bijections/bijection_level.tscn")


func exit() -> void:
	get_tree().change_scene_to_file("res://ChooseTopic/choose_topic.tscn")


func generate_problem() -> void:
	# Choose two random problems
	var problem1: CatalanProblem = CatalanProblems.new().PROBLEMS.values().pick_random()
	var problem2: CatalanProblem = CatalanProblems.new().PROBLEMS.values().pick_random()

	# Make sure they're not the same problem - that would be boring wouldn't it!
	while problem1.description == problem2.description:
		problem2 = CatalanProblems.new().PROBLEMS.values().pick_random()

	# Combine these into one level and assign it
	BijectionSettings.current_level = BijectionLevel.from_catalan_problems(problem1, problem2)

	# Change to the bijection scene
	get_tree().change_scene_to_file("res://Bijections/bijection_level.tscn")
