extends CatalanProblem
class_name CatalanDyckPaths

func _init() -> void:
	super(
		"Dyck Paths",
		"Dyck Paths of length n",
		1,
		[
			DyckPathElement.new([], 1)
		],
		[
			DyckPathElement.new([1, -1], 1)
		],
		[
			DyckPathElement.new([1, 1, -1, -1], 1),
			DyckPathElement.new([1, -1, 1, -1], 2)
		],
		[
			DyckPathElement.new([1, 1, 1, -1, -1, -1], 1),
			DyckPathElement.new([1, 1, -1, 1, -1, -1], 2),
			DyckPathElement.new([1, 1, -1, -1, 1, -1], 3),
			DyckPathElement.new([1, -1, 1, 1, -1, -1], 4),
			DyckPathElement.new([1, -1, 1, -1, 1, -1], 5),
		],
		[
			DyckPathElement.new([1, 1, 1, 1, -1, -1, -1, -1], 1),
			DyckPathElement.new([1, 1, 1, -1, 1, -1, -1, -1], 2),
			DyckPathElement.new([1, 1, 1, -1, -1, 1, -1, -1], 3),
			DyckPathElement.new([1, 1, -1, 1, 1, -1, -1, -1], 4),
			DyckPathElement.new([1, 1, 1, -1, -1, -1, 1, -1], 5),
			DyckPathElement.new([1, -1, 1, 1, 1, -1, -1, -1], 6),
			DyckPathElement.new([1, 1, -1, 1, -1, -1, 1, -1], 7),
			DyckPathElement.new([1, 1, -1, -1, 1, 1, -1, -1], 8),
			DyckPathElement.new([1, -1, 1, 1, -1, 1, -1, -1], 9),
			DyckPathElement.new([1, -1, 1, 1, 1, -1, -1, -1], 10),
			DyckPathElement.new([1, -1, 1, 1, -1, 1, -1, -1], 11),
			DyckPathElement.new([1, -1, 1, 1, -1, -1, 1, -1], 12),
			DyckPathElement.new([1, -1, 1, -1, 1, 1, -1, -1], 13),
			DyckPathElement.new([1, -1, 1, -1, 1, -1, 1, -1], 14),
		],
		{
			0: BijectionProof.new(
				"Bijection: Map ( to an up walk and ) to a down walk.\n\nProof: Trivial",
				0
			)
		},
		[DefinitionDyckPath.new()]
	)
