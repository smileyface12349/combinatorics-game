extends Node

const bijection_width: int = 1500
var bijection_n_scene: PackedScene = preload("res://Bijections/bijection_n.tscn")
var bijection_overview_scene: PackedScene = preload("res://Bijections/Overview/bijection_overview_screen.tscn")
var show_diagrams: bool = false
var bijection_problems: Array[BijectionLevelNode] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_level(BijectionSettings.current_level) 
	
## Creates the elements to represent the level
func create_level(level: BijectionLevel) -> void:
	# Add hints & definitions section
	var instance: BijectionOverviewNode = bijection_overview_scene.instantiate()
	instance.position = Vector2(-500, 500)
	add_child(instance)

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
	add_child(instance)
	bijection_problems.append(instance)

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

# Navigation back
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		BijectionSettings.current_level = null
		get_tree().change_scene_to_file("res://Bijections/bijection_level_select.tscn")
