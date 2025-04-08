extends CatalanProblemDerived
class_name CatalanBinaryTrees

func inner(root: Variant) -> String:
	if root == 0:
		return ""
	if root.size() == 0:
		return ""
	var left: String = inner(root[0])
	var right: String = inner(root[1])
	return "(" + left + ")" + right

func to_parentheses(tree: BinaryTreeElement) -> BijectionElement:
	return BijectionElement.new(inner(tree.root), tree.id)

func _init() -> void:
	super(
		"Binary Trees",
		"Binary Trees with n nodes",
		2,
		# [
		# 	BinaryTreeElement.new([], 1)
		# ],
		# [
		# 	BinaryTreeElement.new([0, 0], 1)
		# ],
		# [
		# 	BinaryTreeElement.new([[0, 0], 0], 1),
		# 	BinaryTreeElement.new([0, [0, 0]], 2),
		# ],
		# [
		# 	BinaryTreeElement.new([[[0, 0], 0], 0], 1),
		# 	BinaryTreeElement.new([[0, [0, 0]], 0], 2),
		# 	BinaryTreeElement.new([[0, 0], [0, 0]], 3),
		# 	BinaryTreeElement.new([0, [[0, 0], 0]], 4),
		# 	BinaryTreeElement.new([0, [0, [0, 0]]], 5),
		# ],
		# [
		# 	# TODO: NOT CHECKED
		# 	BinaryTreeElement.new([[[[0, 0], 0], 0], 0], 1),
		# 	BinaryTreeElement.new([[[0, [0, 0]], 0], 0], 2),
		# 	BinaryTreeElement.new([[[0, 0], [0, 0]], 0], 3),
		# 	BinaryTreeElement.new([[0, [[0, 0], 0]], 0], 4),
		# 	BinaryTreeElement.new([[[0, 0], 0], [0, 0]], 5),
		# 	BinaryTreeElement.new([0, [[[0, 0], 0], 0]], 6),
		# 	BinaryTreeElement.new([[0, [0, 0]], [0, 0]], 7),
		# 	BinaryTreeElement.new([[[0, 0], 0], [0, 0]], 8),
		# 	BinaryTreeElement.new([0, [[0, [0, 0]], 0]], 9),
		# 	BinaryTreeElement.new([[[0, 0], 0], [[0, 0], 0]], 10),
		# 	BinaryTreeElement.new([[[0, 0], 0], [0, [0, 0]]], 11),
		# 	BinaryTreeElement.new([[0, 0], [[0, 0], 0]], 12),
		# 	BinaryTreeElement.new([[0, 0], [0, [0, 0]]], 13),
		# 	BinaryTreeElement.new([0, [0, [0, [0, 0]]]], 14),
		# ],
		{
			0: CatalanBijection.new(
				"Each node is a parenthesis of the form: ( LEFT ) RIGHT",
				to_parentheses,
				"TODO",
				2
			)
		},
		[DefinitionBinaryTree.new()]
	)
