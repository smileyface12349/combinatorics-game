extends BijectionDefinition
class_name DefinitionTableauPair


func _init() -> void:
	super(
		"Tableau Pair",
		"A pair of Young Tableau must both have the same shape.",
		"[[1, 2], [3]], [[1, 3], [2]].",
		"[[1, 2], [3]], [1, 2, 3]]"
	)
