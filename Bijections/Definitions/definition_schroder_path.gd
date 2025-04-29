extends BijectionDefinition
class_name DefinitionSchroderPath


func _init() -> void:
	super(
		"Schroder Path",
		"A Schroder Path of length n is a path starting at (0, 0) consisting of up steps (1, 1), down steps (1, -1), and flat steps (2, 0) such that the y-coordinate is always nonnegative and it finishes on the x-axis."
	)
