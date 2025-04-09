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

func to_complete_tree_inner(subtree: Variant) -> Variant:
    if typeof(subtree) == TYPE_INT and subtree == 0:
        return [0, 0]
    if typeof(subtree) == TYPE_ARRAY and subtree.size() == 0:
        return [0, 0]
    var left: Variant = to_complete_tree_inner(subtree[0])
    var right: Variant = to_complete_tree_inner(subtree[1])
    return [left, right]

class TreeNode:
    var left: TreeNode
    var right: TreeNode
    var count: int
    var max_child_count: int

    # func _init(left: TreeNode, right: TreeNode) -> void:
    #     self.left = left
    #     self.right = right
    #     count = 0
    #     max_child_count = 0

func inorder_traversal(subtree: Variant, count: int) -> TreeNode:
    if typeof(subtree) == TYPE_INT and subtree == 0:
        return null
    if typeof(subtree) == TYPE_ARRAY and subtree.size() == 0:
        return null
    var node: TreeNode = TreeNode.new()
    node.left = inorder_traversal(subtree[0], count)
    if node.left != null:
        count = node.left.max_child_count
    node.count = count
    print("count: ", count)
    count += 1
    node.right = inorder_traversal(subtree[1], count)
    if node.right != null:
        node.max_child_count = node.right.max_child_count
    else:
        node.max_child_count = count
    return node

func to_triangulation_inner(root: TreeNode, base_edge: Array[int]) -> Array:
    # Base case
    if root == null:
        print("Vertex is empty - adding base edge: ", base_edge)
        return [base_edge]

    # Sort base edge in ascending order unless the second one equals 1
    # if base_edge[1] != 1:
    #     if base_edge[0] > base_edge[1]:
    #         var temp: int = base_edge[0]
    #         base_edge[0] = base_edge[1]
    #         base_edge[1] = temp

    print("Considering vertex: ", root.count+2, " base_edge: ", base_edge)

    # Inductive step (draw a line to the in-order traversal and then recurse)
    print("Considering left child: ", root.left)
    var left: Array = to_triangulation_inner(root.left, [base_edge[0], root.count + 2])
    print("Considering right child: ", root.right)
    var right: Array = to_triangulation_inner(root.right, [root.count + 2, base_edge[1]])
    print("Outputting from vertex: ", root.count+2, " left: ", left, " right: ", right, " base_edge: ", base_edge)
    return left + right + [base_edge]
    

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
            ),
            3: CatalanBijection.new(
                "Draw the exterior edges of the (n+2)-gon. Choose the edge (1, 2), then let D = 2 + 1 + # left children. Draw edges (1, D) and (2, D). Recurse on the left child with the polygon (1, n+2, n+1, ..., D) and the right child with the polygon (2, 3, 4, ..., D).",
                func to_triangulation(tree: BinaryTreeElement) -> TriangulationElement:
                    # Perform an in-order traversal on the tree and construct a new tree using the TreeNode class
                    # This has the in-order present and makes manipulation a bit easier
                    print("Tree: ", tree.root)
                    var root: TreeNode = inorder_traversal(tree.root, 1)
                    var triangulation: Array = to_triangulation_inner(root, [2, 1])
                    var num_nodes: int = 0
                    if root != null:
                        num_nodes = root.max_child_count

                    return TriangulationElement.new(
                        num_nodes + 1,
                        triangulation,
                        tree.id
                    ),
            ),
            7: CatalanBijection.new(
                "Add a new left and right child to every node where there isn't one already",
                func to_complete_tree(tree: BinaryTreeElement) -> BinaryTreeElement:
                    return BinaryTreeElement.new(
                        to_complete_tree_inner(tree.root),
                        tree.id
                    ),
                "TODO",
                2
            )
        },
        "Each vertex is an array of length two, where each element is either another array or 0. E.g. 0 is the empty tree, [0, 0] is one node, [0, [0, 0]] is a root and a right child.",
        [DefinitionBinaryTree.new()]
    )
