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
			BijectionElement.new("(())", 1),
			BijectionElement.new("()()", 2)
		],
		[
			BijectionElement.new("((()))", 1),
			BijectionElement.new("(()())", 2),
			BijectionElement.new("(())()", 3),
			BijectionElement.new("()(())", 4),
			BijectionElement.new("()()()", 5)
		],
		[
			BijectionElement.new("(((())))", 1),
			BijectionElement.new("((()()))", 2),
			BijectionElement.new("((())())", 3),
			BijectionElement.new("(()(()))", 4),
			BijectionElement.new("((()))()", 5),
			BijectionElement.new("()((()))", 6),
			BijectionElement.new("(()()())", 7),
			BijectionElement.new("(()())()", 8),
			BijectionElement.new("()(()())", 9),
			BijectionElement.new("(())(())", 10),
			BijectionElement.new("(())()()", 11),
			BijectionElement.new("()(())()", 12),
			BijectionElement.new("()()(())", 13),
			BijectionElement.new("()()()()", 14),
		],
		{
			0: BijectionProof.new(
				"Bijection: Map ( to an up walk and ) to a down walk.\n\nProof: Trivial",
				0
			)
		},
		[DefinitionBinaryTree.new()]
	)
