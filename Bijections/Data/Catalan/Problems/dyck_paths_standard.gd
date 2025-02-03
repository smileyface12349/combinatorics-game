extends CatalanProblem
class_name CatalanDyckPaths

func _init() -> void:
	super(
		"Dyck Paths",
		"Dyck Paths of length n",
		1,
		{
			0: CatalanProblemSize.new(
				0,
				[
					DyckPathElement.new([], 1)
				]
			),
			1: CatalanProblemSize.new(
				1,
				[
					DyckPathElement.new([1, -1], 1)
				]
			),
			2: CatalanProblemSize.new(
				2,
				[
					DyckPathElement.new([1, 1, -1, -1], 1),
					DyckPathElement.new([1, -1, 1, -1], 2)
				]
			)
		},
		{
			0: BijectionProof.new(
				"Bijection: Map ( to an up walk and ) to a down walk.\n\nProof: Trivial",
				0
			)
		},
		[DefinitionDyckPath.new()]
	)
