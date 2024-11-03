extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# A simple undirected graph, in adjacency list format
class Graph:
	var vertices: Array[Vertex]
	
	func _init(num_vertices: int, additional_vertices: Array[Vertex] = []) -> void:
		self.vertices = additional_vertices
		for x: int in range(num_vertices):
			self.vertices.append(Vertex.new())
		
	# Outputs a way of drawing this graph (by positioning the nodes). Might not be very good.
	func get_drawing(width: int, height: int) -> GraphDrawing:
		var positioned_vertices: Array[PositionedVertex] = []
		for vertex: Vertex in self.vertices:
			# TODO: This loses all the pointers
			# TODO: Alternatively, give each node a number, and refer to the edges with these numbers?
			positioned_vertices.append(PositionedVertex.new(vertex, Vector2(randf(), randf())))
		return GraphDrawing.new(width, height, positioned_vertices)
		
	# Draws the graph
	func draw(width: int, height: int, draw_vertex: Callable, draw_edge: Callable) -> void:
		self.get_drawing(width, height).draw(draw_vertex, draw_edge)
		
# A vertex in a graph
class Vertex:
	var neighbours: Array[Vertex]
	
	func _init(neighbours: Array[Vertex] = []) -> void:
		self.neighbours = neighbours
		
# A vertex with position information
# Vertex positions are between (0, 0) and (1, 1).
class PositionedVertex extends Vertex:
	var position: Vector2
	
	func _init(vertex: Vertex, position: Vector2) -> void:
		super(vertex.neighbours)
		self.position = position
	
# A graph where each node has a position
class GraphDrawing:
	var vertices: Array[PositionedVertex]
	var width: int
	var height: int
	
	func _init(width: int, height: int, vertices: Array[PositionedVertex] = []) -> void:
		self.vertices = vertices
		self.width = width
		self.height = height
		
	# Gets the full list of edges
	# If directed = true then each edge is outputted twice. Otherwise, each edge is outputted only
	# once, with the direction of this edge being arbitrary.
	func get_edge_list(directed: bool = false) -> Array[Edge]:
		var edge_list: Array[Edge] = []
		
		for vertex: PositionedVertex in self.vertices:
			for neighbour: PositionedVertex in vertex.neighbours:
				edge_list.append(Edge.new(vertex, neighbour))
				
		# TODO: Don't duplicate edges
				
		return edge_list
	
	# Determines if this particular drawing of the graph is planar.
	func is_planar() -> bool:
		# For each pair of edges...
		for edge1: Edge in self.get_edge_list():
			for edge2: Edge in self.get_edge_list():
				# (that aren't the same)
				if edge1 == edge2:
					continue
					
				# Test if they cross by getting value for t in parametric equation
				var t: float = (edge2.head.x - edge1.head.x) / (edge1.tail.x - edge1.head.x - edge2.tail.x + edge2.head.x)
				if (0 <= t && t <= 1):
					# the lines intersect
					return false
		
		# If we haven't found any intersections, then the drawing of the graph must be planar
		return true
		
	# Converts co-ordinates from (0, 1) to the full viewport size of the graph
	func convert_position(position: Vector2) -> Vector2:
		return Vector2(position.x * width, position.y * height)
		
	func draw(draw_vertex: Callable, draw_edge: Callable) -> void:
		for vertex: PositionedVertex in self.vertices:
			draw_vertex.call(self.convert_position(vertex.position))
			for neighbour: PositionedVertex in vertex.neighbours:
				draw_edge.call(self.convert_position(vertex.position), self.convert_position(neighbour.position))
				
# An edge in a graph (not used in representing graphs, but can be useful in some situations).
# These may be used as directed or undirected edges.
# Feel free to give position information for the vertices.
class Edge:
	var head: Vertex
	var tail: Vertex
	
	func _init(head: Vertex, tail: Vertex) -> void:
		self.head = head
		self.tail = tail

	
