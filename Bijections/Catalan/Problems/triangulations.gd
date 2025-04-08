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
			0: CatalanBijection.new(
				"Map triangulations to Dyck paths",
				func to_dyck_path(triangulation: TriangulationElement) -> DyckPathElement:
					var path: Array[int] = []
					for c: Array[int] in triangulation.triangulation:
						path.append(c[0])
						path.append(c[1])
					return DyckPathElement.new(path, triangulation.id),
				"TODO",
				0
			)
		},
		[DefinitionDyckPath.new()]
	)
