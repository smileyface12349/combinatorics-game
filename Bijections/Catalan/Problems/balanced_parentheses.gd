extends CatalanProblemBase
class_name CatalanParentheses

func to_binary_tree_inner(parentheses: String) -> Variant:
	if parentheses == "":
		return 0
	var height: int = 0
	var closing: int = -1
	for i: int in range(len(parentheses)):
		if parentheses[i] == "(":
			height += 1
		else:
			height -= 1
		if height == 0:
			closing = i
			break
	if closing == -1:
		return 0
	
	var left: Variant = to_binary_tree_inner(parentheses.substr(1, closing - 1))
	var right: Variant = to_binary_tree_inner(parentheses.substr(closing + 1, len(parentheses) - closing - 1))
	return [left, right]


func _init() -> void:
	super(
		"Parentheses",
		"Sequences of n opening and n closing parentheses which are balanced",
		0,
		[
			BijectionElement.new("", 1)
		],
		[
			BijectionElement.new("()", 1)
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
			1: CatalanBijection.new(
				"Map ( to an up walk and ) to a down walk",
				func to_dyck_path(parentheses: BijectionElement) -> DyckPathElement:
					var path: Array[int] = []
					for c: String in parentheses.text:
						if c == "(":
							path.append(1)
						else:
							path.append(-1)
					return DyckPathElement.new(path, parentheses.id),
				"Trivial",
				0
			),
			2: CatalanBijection.new(
				"Map each pair of parentheses to a node and do it recursively, with the form ( LEFT ) RIGHT",
				func to_binary_tree(parentheses: BijectionElement) -> BinaryTreeElement:
					var tree: Variant = to_binary_tree_inner(parentheses.text)
					if typeof(tree) == TYPE_INT and tree == 0:
						return BinaryTreeElement.new([], parentheses.id)
					return BinaryTreeElement.new(tree, parentheses.id),
				"TODO",
				2
			)
		},
		[DefinitionBalancedParentheses.new()]
	)

func generate_elements(n: int) -> Array[BijectionElement]:
	var elements: Array[BijectionElement] = []
	if n == 0:
		elements.append(BijectionElement.new("", 1))
		return elements
	elif n == 1:
		elements.append(BijectionElement.new("()", 1))
		return elements
	else:
		for i: int in range(n):
			for left: BijectionElement in generate_elements(i):
				for right: BijectionElement in generate_elements(n - i - 1):
					elements.append(BijectionElement.new("(" + left.text + ")" + right.text, left.id * right.id))
		return elements
