extends Node

const force_attract: float = 0.2
const force_repel: float = 0.02
const distance_to_edge: float = 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# A simple undirected graph, in adjacency list format
# vertices are integers in the keys of the dictionary. The value is an array of all its neighbours.
class Graph:
	var vertex_neighbours: Dictionary
	
	
	# Initialise a graph with a set of neighbours
	func _init(vertex_neighbours: Dictionary = {}) -> void:
		self.vertex_neighbours = vertex_neighbours
		
	# Fills in every edge not present with the given probability
	func complete_random(edge_chance: float = 0.5) -> Graph:
		# Populate them
		for vertex: int in self.vertex_neighbours.keys():
			for vertex2: int in self.vertex_neighbours.keys():
				if vertex2 in self.vertex_neighbours[vertex] or vertex >= vertex2:
					continue
				if randf() <= edge_chance:
					self.vertex_neighbours[vertex].append(vertex2)
					self.vertex_neighbours[vertex2].append(vertex)
					
		# Return this graph in case it's needed in that way
		return self
		
	# Gets a random graph on n vertices. Each edge is generated with probability edge_chance.
	# Warning: This graph might not be connected.
	static func get_random(n_vertices: int, edge_chance: float = 0.5) -> Graph:
		var vertex_neighbours: Dictionary = {}
	
		for vertex: int in range(n_vertices):
			vertex_neighbours[vertex] = []
			
		return Graph.new(vertex_neighbours).complete_random(edge_chance)
		
	# Generates a random MST on n vertices
	static func get_random_mst(n_vertices: int) -> Graph:
		# Initialise the empty graph
		var vertex_neighbours: Dictionary = {}
		for vertex: int in range(n_vertices):
			vertex_neighbours[vertex] = []
			
		# Create a random MST
		for vertex: int in range(1, n_vertices):
			# Connect each vertex up to one that's already in the MST
			var neighbour: int = randi_range(0, vertex-1)
			vertex_neighbours[vertex].append(neighbour)
			vertex_neighbours[neighbour].append(vertex)
		
		# Return the graph
		return Graph.new(vertex_neighbours)
		
	# Generates a random connected graph by forming a random minimum spanning tree and then
	# generating each other edge with the given chance
	static func get_random_connected(n_vertices: int, edge_chance: float = 0.4) -> Graph:
		var graph: Graph = Graph.get_random_mst(n_vertices)
		graph.complete_random(edge_chance)
		return graph
		
	# Outputs a graph drawing where all nodes are positioned randomly
	func get_drawing_random() -> GraphDrawing:
		var vertex_positions: Dictionary = {}
		for vertex: int in self.vertex_neighbours.keys():
			vertex_positions[vertex] = Vector2(randf(), randf())
		return GraphDrawing.new(vertex_neighbours, vertex_positions)
		
	# Outputs a graph drawing using the Fruchterman-Reingold algorithm such that nodes are spaced
	# far apart, but also close to their neighbours
	# Keeps going until max time or min amount of total movement, whichever comes first.
	func get_drawing_best(max_time: float = 0.1, min_movement: float = 0.01) -> GraphDrawing:
		var drawing: GraphDrawing = self.get_drawing_random()
		var total_movement: float
		var start_time: float = Time.get_unix_time_from_system()
		while (Time.get_unix_time_from_system() - start_time) < max_time:
			total_movement = drawing.improve_spacing()
			if total_movement < min_movement:
				break
		print("Drawing. Final total movement: " + str(total_movement) + ". Time taken: " + str(Time.get_unix_time_from_system() - start_time))
		return drawing
		
	# Draws the graph
	func draw_auto(width: int, height: int, draw_vertex: Callable, draw_edge: Callable) -> void:
		self.get_drawing_best().draw(width, height, draw_vertex, draw_edge)
		
	
# A graph where each node has a position
class GraphDrawing extends Graph:
	var vertex_positions: Dictionary
	
	func _init(vertex_neighbours: Dictionary = {}, vertex_positions: Dictionary = {}) -> void:
		super(vertex_neighbours)
		self.vertex_positions = vertex_positions
		
	func get_vertex_info(vertex: int) -> PositionedVertex:
		return PositionedVertex.new(vertex, self.vertex_positions[vertex])
		
	# Gets the full list of edges
	# This will return each edge twice, one for each direction.
	func get_edge_list() -> Array[Edge]:
		var edge_list: Array[Edge]
		
		for vertex: int in self.vertex_neighbours.keys():
			for neighbour: int in self.vertex_neighbours[vertex]:
				edge_list.append(Edge.new(
					self.get_vertex_info(vertex), 
					self.get_vertex_info(neighbour)
				))

		return edge_list
		
	# Gets the full list of edges, but only outputs each edge once
	# Edges always have the endpoint with the lowest id first, then the higher id
	func get_undirected_edge_list() -> Array[Edge]:
		var edge_list: Array[Edge]
		
		for vertex: int in self.vertex_neighbours.keys():
			for neighbour: int in self.vertex_neighbours[vertex]:
				if vertex > neighbour:
					continue
				edge_list.append(Edge.new(
					self.get_vertex_info(vertex), 
					self.get_vertex_info(neighbour)
				))
				
		return edge_list
	
	# Determines if this particular drawing of the graph is planar.
	func is_planar() -> bool:
		# For each pair of edges...
		for edge1: Edge in self.get_undirected_edge_list():
			for edge2: Edge in self.get_undirected_edge_list():
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
		
	# Repositions the nodes to (hopefully) lead to a better drawing
	# Outputs the total amount of movement (you may want to use this to detect convergence)
	func improve_spacing() -> float:
		# Initialise forces to zero
		var forces: Dictionary
		for vertex: int in self.vertex_neighbours:
			forces[vertex] = Vector2(0, 0)
			
		# Repulsive forces
		for vertex: int in self.vertex_neighbours:
			for vertex2: int in self.vertex_neighbours:
				if vertex == vertex2:
					continue
				var displacement: Vector2 = self.vertex_positions[vertex2] - self.vertex_positions[vertex]
				var force: float = force_repel / displacement.length()
				#print("Repulsive force acting on vertex " + str(vertex) + " from vertex " + str(vertex2) + " of magnitude " + str(force))
				forces[vertex] -= displacement.normalized() * force
				
		# Attractive forces
		for edge: Edge in self.get_undirected_edge_list():
			var displacement: Vector2 = edge.head.position - edge.tail.position
			var force: float = force_attract * displacement.length_squared()
			forces[edge.head.id] -= displacement.normalized() * force
			forces[edge.tail.id] += displacement.normalized() * force
			#print("Attractive force between vertices " + str(edge.head.id) + " and " + str(edge.tail.id) + " of magnitude " + str(force))
			
		# Move the nodes accordingly
		for vertex: int in forces.keys():
			self.vertex_positions[vertex] += forces[vertex]
			
		# Squash everything inwards to keep it in bounds
		for vertex: int in self.vertex_neighbours:
			var displacement: Vector2 = self.vertex_positions[vertex] - Vector2(0.5, 0.5)
			
			# If we're already out of bounds, we need to come back in. Otherwise, apply a force.
			var force: float
			if displacement.length() > 0.5:
				force = displacement.length() - 0.5 + distance_to_edge
				#print("Vertex " + str(vertex) + " was out of bounds")
			else:
				# Equation: 0.1(2x)^3  (if distance to edge is 0.5
				force = distance_to_edge * pow((2*displacement.length()), 3)
			#print("Boundary force applied to vertex " + str(vertex) + " of magnitude " + str(force))
			self.vertex_positions[vertex] -= displacement.normalized() * force
			forces[vertex] -= displacement.normalized() * force
			
		# Output total amount of movement (use this to detect convergence)
		var total_force: float = 0
		for force: Vector2 in forces.values(): 
			total_force += force.length()
		return total_force
		
	# Converts co-ordinates from (0, 1) to the full viewport size of the graph
	func convert_position(position: Vector2, width: int, height: int) -> Vector2:
		return Vector2(position.x * width, position.y * height)
		
	func get_draw_pos(vertex: int, width: int, height: int) -> Vector2:
		return self.convert_position(self.vertex_positions[vertex], width, height)
		
	func draw(width: int, height: int, draw_vertex: Callable, draw_edge: Callable) -> void:
		for vertex: int in self.vertex_neighbours.keys():
			draw_vertex.call(self.get_draw_pos(vertex, width, height))
			for neighbour: int in self.vertex_neighbours[vertex]:
				draw_edge.call(self.get_draw_pos(vertex, width, height), self.get_draw_pos(neighbour, width, height))
				
# An edge in a graph (not used in representing graphs, but can be useful in some situations).
# These may be used as directed or undirected edges.
# Feel free to give position information for the vertices.
class Edge:
	var head: PositionedVertex
	var tail: PositionedVertex
	
	func _init(head: PositionedVertex, tail: PositionedVertex) -> void:
		self.head = head
		self.tail = tail

# Not used internally when storing graphs, but can be used when returning values
class Vertex:
	var id: int
	
	func _init(id: int) -> void:
		self.id = id

# Not used internally when storing graphs, but can be used when returning values
class PositionedVertex extends Vertex:
	var position: Vector2
	
	func _init(id: int, position: Vector2) -> void:
		super(id)
		self.position = position
