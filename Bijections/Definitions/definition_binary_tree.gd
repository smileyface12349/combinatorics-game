extends BijectionDefinition
class_name DefinitionBinaryTree


func _init() -> void:
	super(
		"Binary Tree",
		"A Binary Tree consists of a root node. Each node may have a left child (another node, or no left child), and a right child (another node, or no right child). We also permit the empty tree on 0 nodes. We do not label the vertices, so any two trees with the same structure are the same.",
		"The following trees on two nodes are considered different: The root and one child to its left, The root and one child to its right."
	)
