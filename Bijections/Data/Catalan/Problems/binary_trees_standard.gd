extends CatalanProblem
class_name CatalanBinaryTrees

func _init() -> void:
	super(
		"Binary Trees",
		"Binary Trees with n nodes",
		1,
		[
			BinaryTreeElement.new([], 1)
		],
		[
			BinaryTreeElement.new([0, 0], 1)
		],
		[
			BinaryTreeElement.new([[0, 0], 0], 1),
			BinaryTreeElement.new([0, [0, 0]], 2),
		],
		[
			BinaryTreeElement.new([[[0, 0], 0], 0], 1),
			BinaryTreeElement.new([[0, [0, 0]], 0], 2),
			BinaryTreeElement.new([[0, 0], [0, 0]], 3),
			BinaryTreeElement.new([0, [[0, 0], 0]], 4),
			BinaryTreeElement.new([0, [0, [0, 0]]], 5),
		],
		[
			# TODO: NOT CHECKED
			BinaryTreeElement.new([[[[0, 0], 0], 0], 0], 1),
			BinaryTreeElement.new([[[0, [0, 0]], 0], 0], 2),
			BinaryTreeElement.new([[[0, 0], [0, 0]], 0], 3),
			BinaryTreeElement.new([[0, [[0, 0], 0]], 0], 4),
			BinaryTreeElement.new([[[0, 0], 0], [0, 0]], 5),
			BinaryTreeElement.new([0, [[[0, 0], 0], 0]], 6),
			BinaryTreeElement.new([[0, [0, 0]], [0, 0]], 7),
			BinaryTreeElement.new([[[0, 0], 0], [0, 0]], 8),
			BinaryTreeElement.new([0, [[0, [0, 0]], 0]], 9),
			BinaryTreeElement.new([[[0, 0], 0], [[0, 0], 0]], 10),
			BinaryTreeElement.new([[[0, 0], 0], [0, [0, 0]]], 11),
			BinaryTreeElement.new([[0, 0], [[0, 0], 0]], 12),
			BinaryTreeElement.new([[0, 0], [0, [0, 0]]], 13),
			BinaryTreeElement.new([0, [0, [0, [0, 0]]]], 14),
		],
		{
			0: BijectionProof.new(
				"Bijection: Map ( to an up walk and ) to a down walk.\n\nProof: Trivial",
				0
			)
		},
		[DefinitionBinaryTree.new()]
	)
