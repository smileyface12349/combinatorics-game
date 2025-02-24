extends BijectionElement
class_name BinaryTreeElement

var root: Array # Each node is an array of length 2. Each value should be either another array, or a 0. For example, [0, 0] is a leaf node. [0, [0, 0]]. Is a node with only one child that is on the right, and is a leaf.
# SPECIAL CASE: The empty tree should be represented by an empty array, and not 0.

func _init(root: Array, id: int) -> void:
	self.root = root

	# Initialise super
	super(get_string(root), id)

# No text representation for this
func draw_contents_text() -> void:
	draw_contents_diagrams()

# TODO: Get depth of tree
func get_max_height(root: Array, height: int, max_height: int) -> int:
	var left: int
	if typeof(root[0]) != TYPE_ARRAY:
		# No left child - might be a leaf so need to update
		left = max(height, max_height)
	else:
		left = get_max_height(root[0], height+1, max_height)
	var right: int
	if typeof(root[1]) != TYPE_ARRAY:
		# No right child - might be a leaf so need to update
		right = max(height, max_height)
	else:
		right = get_max_height(root[1], height+1, max_height)
	
	return max(left, right)


# Get the required width (min and max x-coordinates)
func get_width(root: Array, x: int, min_x: int, max_x: int) -> Array[int]:
	# Consider left child
	var left_results: Array
	if typeof(root[0]) != TYPE_ARRAY:
		# For leaf nodes, consider the position of the leaf node itself
		left_results = [min(x, min_x), max(x, max_x)]
	elif typeof(root[0]) == TYPE_ARRAY:
		left_results = get_width(root[0], x-1, min_x,  max_x)
	# Consider right child
	var right_results: Array
	if typeof(root[1]) != TYPE_ARRAY:
		# For leaf nodes, consider the position of the leaf node itself
		right_results = [min(x, min_x), max(x, max_x)]
	elif typeof(root[1]) == TYPE_ARRAY:
		right_results = get_width(root[1], x+1, min_x, max_x)
	# Return the min/max from all of these
	return [min(left_results[0], right_results[0]), max(left_results[1], right_results[1])]

# Get a string representation of a subtree
func get_string(node: Array) -> String:
	if node == []:
		return "Empty Tree"
	
	var text: String = "{"
	if typeof(node[0]) == TYPE_ARRAY:
		text += "L: " + get_string(node[0])
	if typeof(node[1]) == TYPE_ARRAY:
		text += "R: " + get_string(node[1])
	if text == "{":
		text += "leaf"
	text += "}"

	return text


# # Traverses the tree and gets a suitable position for the nodes and edges, adding them to the list. Works recursively.
# func traverse_and_position(root, nodes, edges)

# Constants used in drawing Binary Trees
const horizontal_padding: int = 32
const vertical_padding: int = 32
const max_square_size: int = 48
const line_width: int = 2
const dot_radius: int = 5

# Draw a visual representation of the Binary Tree
# - Find out how big each edge should be
# - Traverse the tree and draw it
func draw_contents_diagrams() -> void:
	# Special for empty tree
	if self.root == []:
		draw_empty()
		return

	# Get required width
	var min_max: Array[int] = get_width(self.root, 0, 10000, -10000)
	var required_width: int = min_max[1] - min_max[0]

	# Get required height
	var required_height: int = get_max_height(self.root, 0, 0)

	# Work out how much space we have to work with
	var available_space: Vector2 = size - Vector2(horizontal_padding * 2, vertical_padding * 2)
	
	# Work out the length and width of the squares if we want to fill this space
	var max_square_width: int = available_space.x / required_width
	var max_square_height: int = available_space.y / required_height
	
	# We want to keep the squares square, but this can be changed to allow for rectangles
	var square_size: int = min(max_square_width, max_square_height)
	
	# Let's stop it from getting silly by restricting the maximum size (only affects small numbers)
	square_size = min(square_size, max_square_size)

	# Draw it
	draw_recurse(self.root, horizontal_padding + available_space.x / 2, vertical_padding, square_size)
	
	# # Draw a dot to begin with
	# var y: int = size.y - vertical_padding
	# var x: int = horizontal_padding
	# draw_circle(Vector2(x, y), dot_radius, Color.BLACK)

	# # Now we can go through each step and draw the rest of it
	
	# for step: int in steps:
	# 	# work out the next position
	# 	var new_x: int = x + square_size
	# 	var new_y: int = y + square_size * step * -1
		
	# 	# draw a line between these points
	# 	draw_line(Vector2(x, y), Vector2(new_x, new_y), Color.BLACK, line_width)
		
	# 	# update the co-ordinates
	# 	x = new_x
	# 	y = new_y
		
	# 	# draw a dot at the end of the line
	# 	draw_circle(Vector2(x, y), dot_radius, Color.BLACK)
		
func draw_recurse(root: Array, x: int, y: int, square_size: int) -> void:
	# Draw this node
	draw_circle(Vector2(x, y), dot_radius, Color.BLACK)

	# Draw the left child (if applicable)
	if typeof(root[0]) == TYPE_ARRAY:
		draw_line(Vector2(x, y), Vector2(x-square_size, y+square_size), Color.BLACK, line_width)
		draw_recurse(root[0], x-square_size, y+square_size, square_size)
	
	# Draw the right child (if applicable)
	if typeof(root[1]) == TYPE_ARRAY:
		draw_line(Vector2(x, y), Vector2(x+square_size, y+square_size), Color.BLACK, line_width)
		draw_recurse(root[1], x+square_size, y+square_size, square_size)
	
	
