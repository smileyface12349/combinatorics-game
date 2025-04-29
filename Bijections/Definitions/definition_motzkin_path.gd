extends BijectionDefinition
class_name DefinitionMotzkinPath


func _init() -> void:
	super(
		"Motzkin Path",
		"A Motzkin Path of length n is a path starting at (0, 0) consisting of up steps (1, 1), down steps (1, -1), and flat steps (1, 0) such that the y-coordinate is always nonnegative and it finishes on the x-axis."
	)
