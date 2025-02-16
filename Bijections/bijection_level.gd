extends Node

const bijection_width: int = 1500
var bijection_n_scene: PackedScene = preload("res://Bijections/bijection_n.tscn")
var bijection_overview_scene: PackedScene = preload("res://Bijections/Overview/bijection_overview_screen.tscn")
var show_diagrams: bool = false
var bijection_problems: Array[BijectionLevelNode] = []
var bijection_overview: BijectionOverviewNode
var hints: Array[String] = []
var hints_available: int = 5
var level_hint: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_level(BijectionSettings.current_level) 
	
## Creates the elements to represent the level
func create_level(level: BijectionLevel) -> void:
	# Add hints & definitions section
	bijection_overview = bijection_overview_scene.instantiate()
	bijection_overview.position = Vector2(-500, 500)
	bijection_overview.set_definitions(level.definitions)
	level_hint = level.hint
	if level_hint == "":
		bijection_overview.hide_hint_button()
	bijection_overview.request_level_hint = request_level_hint
	add_child(bijection_overview)

	# Add the bijections
	var position: Vector2 = Vector2(1000, 500)
	for problem_size: int in level.bijections:
		create_bijection_n(level.bijections[problem_size], level, position)
		position.x += bijection_width

## Create the elements to represent a bijection of particular size n
func create_bijection_n(bijection: Bijection, level: BijectionLevel, position: Vector2) -> void:
	var instance: BijectionLevelNode = bijection_n_scene.instantiate()
	instance.set_bijection(bijection)
	instance.set_level(
		level,
		# Function that is called when the show diagrams button is toggled
		# Lambda so we can tell it which problem toggled it, so we don't tell a problem that caused
		# the signal to toggle itself
		func set_show_diagrams(show_diagrams: bool) -> void:
			set_show_diagrams(show_diagrams, len(bijection_problems))
	)
	instance.position = position
	instance.set_callback_on_match(check_all)
	instance.set_add_hint(add_hint)
	instance.available_hints = hints_available
	add_child(instance)
	bijection_problems.append(instance)

# Call this from anywhere to spend a new hint. Include a string representation of the information learned by the user for the log.
func add_hint(hints_spent: int, hint: String) -> void:
	# Display the hint
	hints.append(hint)
	bijection_overview.set_hints(hints)

	# Reduce the number of hints available
	hints_available -= hints_spent

	# Ensure the user can't use too many hints
	for node: BijectionLevelNode in bijection_problems:
		node.set_hints_available(hints_available)

	# Update visual display of available hints
	bijection_overview.set_available_hints(hints_available)

# Shows the level hint
func request_level_hint() -> void:
	if hints_available >= 1:
		add_hint(1, "[u]Hint[/u]: " + level_hint)
		bijection_overview.hide_hint_button()


func set_show_diagrams(show_diagrams: bool, origin_problem: int) -> void:
	# Update it for us
	self.show_diagrams = show_diagrams
	# Tell all of the problems about the change so they can update their own state
	for i: int in range(len(bijection_problems)):
		if i != origin_problem:
			bijection_problems[i].set_show_diagrams(show_diagrams)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Called every time it updates. Checks if everything is correct and updates accordingly.
func check_all() -> void:
	# Check if they are all complete
	var complete: bool = true
	for problem_n: BijectionLevelNode in bijection_problems:
		if not problem_n.is_complete():
			complete = false
			break
			
	# If not, there's no point going any further
	if not complete:
		for problem_n: BijectionLevelNode in bijection_problems:
			problem_n.show_incorrect(false)
		return
	
	# Check if they are all correct
	var correct: bool = true
	for problem_n: BijectionLevelNode in bijection_problems:
		if not problem_n.check():
			correct = false
			break
	
	# All correct - tell them to update their appearance accordingly
	if correct:
		for problem_n: BijectionLevelNode in bijection_problems:
			problem_n.mark_as_done()
			
	# At least one is wrong - make sure they are all red
	else:
		for problem_n: BijectionLevelNode in bijection_problems:
			problem_n.show_incorrect()

# Navigation back
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if BijectionSettings.current_level.is_catalan:
			BijectionSettings.current_level = null
			get_tree().change_scene_to_file("res://Bijections/Catalan/catalan_menu.tscn")
		else:
			BijectionSettings.current_level = null
			get_tree().change_scene_to_file("res://Bijections/LevelSelect/lake_level_select.tscn")
