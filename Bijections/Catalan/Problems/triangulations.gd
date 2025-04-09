extends CatalanProblemDerived
class_name CatalanTriangulations

func _init() -> void:
	super(
		"Triangulations",
		"Triangulations of an (n+2)-gon",
		3,
		# [
		# 	TriangulationElement.new(2, [], 1)
		# ],
		# [
		# 	TriangulationElement.new(3, [], 1)
		# ],
		# [
		# 	TriangulationElement.new(4, [[1, 3]], 1),
		# 	TriangulationElement.new(4, [[2, 4]], 2),
		# ],
		# [
		# 	# DISCLAIMER: ORDER HAS NOT BEEN CHECKED
		# 	TriangulationElement.new(5, [[1, 3], [1, 4]], 1),
		# 	TriangulationElement.new(5, [[1, 3], [3, 5]], 2),
		# 	TriangulationElement.new(5, [[2, 4], [2, 5]], 3),
		# 	TriangulationElement.new(5, [[2, 4], [1, 4]], 4),
		# 	TriangulationElement.new(5, [[2, 5], [3, 5]], 5),
		# ],
		# [
		# 	DyckPathElement.new([1, 1, 1, 1, -1, -1, -1, -1], 1),
		# 	DyckPathElement.new([1, 1, 1, -1, 1, -1, -1, -1], 2),
		# 	DyckPathElement.new([1, 1, 1, -1, -1, 1, -1, -1], 3),
		# 	DyckPathElement.new([1, 1, -1, 1, 1, -1, -1, -1], 4),
		# 	DyckPathElement.new([1, 1, 1, -1, -1, -1, 1, -1], 5),
		# 	DyckPathElement.new([1, -1, 1, 1, 1, -1, -1, -1], 6),
		# 	DyckPathElement.new([1, 1, -1, 1, -1, -1, 1, -1], 7),
		# 	DyckPathElement.new([1, 1, -1, -1, 1, 1, -1, -1], 8),
		# 	DyckPathElement.new([1, -1, 1, 1, -1, 1, -1, -1], 9),
		# 	DyckPathElement.new([1, -1, 1, 1, 1, -1, -1, -1], 10),
		# 	DyckPathElement.new([1, -1, 1, 1, -1, 1, -1, -1], 11),
		# 	DyckPathElement.new([1, -1, 1, 1, -1, -1, 1, -1], 12),
		# 	DyckPathElement.new([1, -1, 1, -1, 1, 1, -1, -1], 13),
		# 	DyckPathElement.new([1, -1, 1, -1, 1, -1, 1, -1], 14),
		# ],
		{
			2: CatalanBijection.new(
				"TODO",
				func to_binary_tree(triangulation: TriangulationElement) -> BinaryTreeElement:
					# TODO
					return BinaryTreeElement.new(
						[0, 0],
						1
					),
				"TODO",
				0
			)
		},
		"An array of interior edges e.g. [[1, 3], [2, 4]]",
		[DefinitionDyckPath.new()]
	)
