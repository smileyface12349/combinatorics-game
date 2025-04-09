extends BijectionElement
class_name TriangulationElement

var edges: Array
var vertices: int

# Edges is a list of edges that forms the triangulation. Vertices are numbered 1, 2, ..., n
func _init(vertices: int, edges: Array, id: int) -> void:
	self.edges = edges
	self.vertices = vertices

	# Initialise super
	super("Edges: " + str(edges), id)

# No text representation for this
func draw_contents_text() -> void:
	draw_contents_diagrams()


# # Traverses the tree and gets a suitable position for the nodes and edges, adding them to the list. Works recursively.
# func traverse_and_position(root, nodes, edges)

# Constants used in drawing Triangulations
const horizontal_padding: int = 32
const vertical_padding: int = 16
const line_width: int = 2

func draw_line_between_vertices(v1: int, v2: int) -> void:
	#print("Drawing a line between vertices " + str(v1) + " and " + str(v2))
	var radius: float = min(size.y - vertical_padding*2, size.x - horizontal_padding*2) / 2
	var centre: Vector2 = size / 2
	var angle_increment: float = PI * 2 / vertices

	#print("Start point of line: " + str(Vector2(centre.x + radius * cos(angle_increment * v1), centre.y + radius * sin(angle_increment * v1))))

	draw_line(Vector2(centre.x + radius * cos(angle_increment * v1), centre.y + radius * sin(angle_increment * v1)),
			  Vector2(centre.x + radius * cos(angle_increment * v2), centre.y + radius * sin(angle_increment * v2)),
			  Color.BLACK,
			  line_width
	)

# Draw a visual representation of the Triangulation
# - Find out the positions for each of the vertices
# - Draw the edges
func draw_contents_diagrams() -> void:

	# Draw the outside edges
	for i: int in range(vertices):
		# Draw a line from vertex i to vertex (i+1)
		draw_line_between_vertices(i, i+1)

	# Draw the inside edges
	for edge: Array in self.edges:
		draw_line_between_vertices(edge[0], edge[1])

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
		

func get_code_representation() -> Array[Array]:
	# Remove any edges between consecutive vertices (these are on the outside and are not needed)
	var edges_copy: Array = []
	for edge: Array in self.edges:
		if edge[0] != edge[1] and (edge[0] + 1) % vertices != edge[1]:
			edges_copy.append(edge)
	return edges_copy
