extends CatalanProblemDerived
class_name CatalanBinaryTreesComplete

func to_binary_tree_inner(complete_subtree: Array) -> Variant:
    if complete_subtree == [0, 0]:
        return 0
    if complete_subtree.size() == 0:
        return 0
    var left: Variant = to_binary_tree_inner(complete_subtree[0])
    var right: Variant = to_binary_tree_inner(complete_subtree[1])
    return [left, right]

func _init() -> void:
    super(
        "Complete Trees",
        "Complete Binary Trees with 2n+1 nodes",
        7,
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
            2: CatalanBijection.new(
                "Remove all leaves",
                func to_binary_tree(complete_binary_tree: BinaryTreeElement) -> BinaryTreeElement:
                    return BinaryTreeElement.new(
                        to_binary_tree_inner(complete_binary_tree.root),
                        complete_binary_tree.id
                    ),
                "TODO",
                2
            )
        },
        "Each vertex is an array of length two, where each element is either another array or 0. E.g. 0 is the empty tree, [0, 0] is one node, [0, [0, 0]] is a root and a right child.",
        [
            DefinitionBinaryTree.new(),
            DefinitionComplete.new()
        ]
    )
