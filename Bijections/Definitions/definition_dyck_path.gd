extends BijectionDefinition
class_name DefinitionDyckPath


func _init() -> void:
	super(
		"Dyck Path",
		"A Dyck Path of length n is a path starting at (0, 0) consisting of n up steps (1, 1) and n down steps (1, -1) such that the y-coordinate is always nonnegative."
	)
