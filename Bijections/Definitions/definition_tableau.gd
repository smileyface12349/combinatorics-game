extends BijectionDefinition
class_name DefinitionTableau


func _init() -> void:
	super(
		"Young Tableau",
		"A young tableau of size n consists of n boxes each with a distinct value from {1, ..., n}. The boxes are arranged in rows and columns such that the values in each row are increasing from left to right and the values in each column are increasing from top to bottom. The size of the rows must be non-increasing.",
		"[[1, 2], [3]], [[1], [2], [3]], [[1, 2, 3]].",
		"[[2, 1], [3]], [[2, 1, 3]], [[1], [2, 3]]"
	)
