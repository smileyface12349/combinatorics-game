extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	# ESC to go back to menu
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Menu/menu.tscn")
	
	# Buttons to change level
	if Input.is_action_just_pressed("num_0"):
		BijectionSettings.current_level = BijectionLevel0.new()
	elif Input.is_action_just_pressed("num_1"):
		BijectionSettings.current_level = BijectionLevel1.new()
	elif Input.is_action_just_pressed("num_2"):
		BijectionSettings.current_level = BijectionLevel2.new()
	elif Input.is_action_just_pressed("num_4"):
		BijectionSettings.current_level = BijectionLevel4.new()
		
	# Catalan number zone (temporary)
	elif Input.is_action_just_pressed("num_9"):
		# Choose two random problems
		var problem1: CatalanProblem = CatalanProblems.new().PROBLEMS.pick_random()
		var problem2: CatalanProblem = CatalanProblems.new().PROBLEMS.pick_random()
		# Make sure they're not the same problem - that would be boring wouldn't it!
		while problem1.description == problem2.description:
			problem2 = CatalanProblems.new().PROBLEMS.pick_random()
		# Combine these into one level and assign it
		BijectionSettings.current_level = BijectionLevel.from_catalan_problems(problem1, problem2)
	
	# Test level
	elif Input.is_action_just_pressed("ui_accept"):
		BijectionSettings.current_level = BijectionLevelTest.new()
	
	# If they chose a level
	if BijectionSettings.current_level != null:
		get_tree().change_scene_to_file("res://Bijections/bijection_level.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
