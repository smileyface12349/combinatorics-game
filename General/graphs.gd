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
		
	# Determines what edge chance you need to obtain this average degree
	static func get_edge_chance(n_vertices: int, average_degree: int) -> float:
		return (average_degree * n_vertices) / pow(2, n_vertices + 1)
		
	# Determines what edge chance you need to obtain this average_degree, when starting from an mst
	static func get_edge_chance_from_mst(n_vertices: int, average_degree: int) -> float:
		return ((average_degree-2) * n_vertices + 2) / (pow(2, n_vertices) - n_vertices + 1) / 2
		
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
	func draw_auto(size: Vector2, draw_vertex: Callable, draw_edge: Callable) -> void:
		self.get_drawing_best().draw(size, draw_vertex, draw_edge)
		
	# Determines if there exists a planar drawing for this graph
	func is_planar() -> bool:
		return true # TODO
		
	
# A graph where each node has a position
class GraphDrawing extends Graph:
	var vertex_positions: Dictionary
	var edge_crossings_cache: Array[Edge]
	var edge_crossings_cache_invalidate: bool
	
	func _init(vertex_neighbours: Dictionary = {}, vertex_positions: Dictionary = {}) -> void:
		super(vertex_neighbours)
		self.vertex_positions = vertex_positions
		self.edge_crossings_cache = []
		self.edge_crossings_cache_invalidate = true
		
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
				if vertex >= neighbour:
					continue
				edge_list.append(Edge.new(
					self.get_vertex_info(vertex), 
					self.get_vertex_info(neighbour)
				))
				
		return edge_list
	
	# Gets all of the edges that cross with other edges
	# WARNING: This might be cached. Please make sure to invalidate the cache when the graph is changed
	func get_crossing_edges() -> Array[Edge]:
		if self.edge_crossings_cache_invalidate:
			self.edge_crossings_cache = self.force_get_crossing_edges()
			self.edge_crossings_cache_invalidate = false
		return self.edge_crossings_cache
		
	func invalidate_edge_crossings_cache() -> void:
		self.edge_crossings_cache_invalidate = true
		
	func force_get_crossing_edges() -> Array[Edge]:
		var edges: Array[Edge] = []

		for edge1: Edge in self.get_undirected_edge_list():
			for edge2: Edge in self.get_undirected_edge_list():
				# only consider each pair once
				if not (edge1.head.id < edge2.head.id || (edge1.head.id == edge2.head.id && edge1.tail.id < edge2.tail.id)):
					continue
					
				#print("Considering edges " + str(edge1) + " and " + str(edge2))
				if test_edge_crossing(edge1, edge2):
					if not self.is_edge_in_list(edge1, edges):
						edges.append(edge1)
					if not self.is_edge_in_list(edge2, edges):
						edges.append(edge2)
		
		return edges
		
	# Gets all the edges not listed in the input
	func get_other_edges(edges: Array[Edge]) -> Array[Edge]:
		var other_edges: Array[Edge] = []
		for edge: Edge in self.get_undirected_edge_list():
			if not self.is_edge_in_list(edge, edges):
				other_edges.append(edge)
		return other_edges
		
	static func is_edge_in_list(edge: Edge, edges: Array[Edge]) -> bool:
		var in_test: bool = false
		for edge_in_test: Edge in edges:
			if edge.head.id == edge_in_test.head.id and edge.tail.id == edge_in_test.tail.id:
				# these are the same edge
				in_test = true
				break
		return in_test
		
	
	# Determines if this particular drawing of the graph is planar.
	func is_drawing_planar() -> bool:
		return self.get_crossing_edges().is_empty()
		
	# Test if two edges cross
	# TODO: This code doesn't work. Make a new system to detect edge crossings in the Edge class
	static func test_edge_crossing(edge1: Edge, edge2: Edge) -> bool:
		var t: float = (edge2.head.position.x - edge1.head.position.x) / (edge1.tail.position.x - edge1.head.position.x - edge2.tail.position.x + edge2.head.position.x)
		var t2: float = (edge2.head.position.y - edge1.head.position.y) / (edge1.tail.position.y - edge1.head.position.y - edge2.tail.position.y + edge2.head.position.y)
		print("x: " + str(t) + ", y: " + str(t2) + ", result: " + str((0 <= t && t <= 1) && (0 <= t2 && t2 <= 1)))
		return (0.05 <= t && t <= 0.95) && (0.05 <= t2 && t2 <= 0.95)
		
		# StackOverflow version
		#return ccw(edge1.head, edge2.head, edge2.tail) != ccw(edge1.tail, edge2.head, edge2.tail) \
			#and ccw(edge1.head, edge1.tail, edge2.head) != ccw(edge1.head, edge1.tail, edge2.tail)
	
	# credit: https://stackoverflow.com/questions/3838329/how-can-i-check-if-two-segments-intersect
	static func ccw(A: PositionedVertex, B: PositionedVertex, C: PositionedVertex) -> float:
		return (C.position.y-A.position.y) * (B.position.x-A.position.x) \
			> (B.position.y-A.position.y) * (C.position.x-A.position.x)
		
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
		
	# Forces a vertex inside bounds (moves it onto the boundary)
	func keep_vertex_inside(vertex: int) -> void:
		if self.vertex_positions[vertex].x < 0:
			self.vertex_positions[vertex].x = 0
		if self.vertex_positions[vertex].x > 1:
			self.vertex_positions[vertex].x = 1
		if self.vertex_positions[vertex].y < 0:
			self.vertex_positions[vertex].y = 0
		if self.vertex_positions[vertex].y > 1:
			self.vertex_positions[vertex].y = 1
		
	# Converts co-ordinates from (0, 1) to the full viewport size of the graph
	static func vertex_to_world(position: Vector2, viewport_size: Vector2) -> Vector2:
		return Vector2(position.x * viewport_size.x, position.y * viewport_size.y)
		
	# Converts co-ordinates from the full viewport size of the graph to (0, 1)
	static func world_to_vertex(position: Vector2, viewport_size: Vector2) -> Vector2:
		return Vector2(position.x / viewport_size.x, position.y / viewport_size.y)
		
	func get_draw_pos(vertex: int, viewport_size: Vector2) -> Vector2:
		return self.vertex_to_world(self.vertex_positions[vertex], viewport_size)
		
	func draw(size: Vector2, draw_vertex: Callable, draw_edge: Callable, compute_crossings: bool = false) -> void:
		# Draw edges first so that they are behind
		if compute_crossings:
			var crossing_edges: Array[Edge] = self.get_crossing_edges()
			# Draw non-crossing edges first
			for edge: Edge in self.get_other_edges(crossing_edges):
				draw_edge.call(self.get_draw_pos(edge.head.id, size), self.get_draw_pos(edge.tail.id, size), false)
			# Then emphasise the edges that are crossing over others
			for edge: Edge in crossing_edges:
				draw_edge.call(self.get_draw_pos(edge.head.id, size), self.get_draw_pos(edge.tail.id, size), true)
		else:
			for edge: Edge in self.get_undirected_edge_list():
				draw_edge.call(self.get_draw_pos(edge.head.id, size), self.get_draw_pos(edge.tail.id, size))
			
		# Draw vertices second
		for vertex: int in self.vertex_neighbours.keys():
			draw_vertex.call(self.get_draw_pos(vertex, size), vertex)
			
	# Get a rearrangeable version of the graph
	func get_rearrangeable() -> RearrangeableGraphDrawing:
		return RearrangeableGraphDrawing.new(self.vertex_neighbours, self.vertex_positions)


# A class to handle a graph that can be rearranged by the user. Don't forget to keep it updated
# with the current mouse position and any mouse clicks!
class RearrangeableGraphDrawing extends GraphDrawing:
	var selected_vertex: int
	var selected_vertex_offset_from_mouse: Vector2
	var mouse_position: Vector2
	var size: Vector2
	
	func _init(vertex_neighbours: Dictionary = {}, vertex_positions: Dictionary = {}) -> void:
		super(vertex_neighbours, vertex_positions)
		self.selected_vertex = -1
		self.mouse_position = Vector2(0, 0)
		self.size = Vector2(0, 0)
		
	# Resize the drawing. This can instead be done when calling draw().
	func resize(new_size: Vector2) -> void:
		self.size = new_size
	
	# Check if mouse is hovering over this vertex. Last drawn size is used
	func is_hovering_over_vertex(vertex: int, vertex_radius: int = 10) -> bool:
		return (
			self.vertex_to_world(self.vertex_positions[vertex], self.size) 
		   -self.vertex_to_world(self.mouse_position, self.size)
		).length() <= vertex_radius
		
	func get_vertex_at_mouse() -> int:
		for vertex: int in self.vertex_positions.keys():
			if self.is_hovering_over_vertex(vertex):
				return vertex
		return -1

	func mouse_moved(new_position: Vector2) -> void:
		self.mouse_position = new_position
		if self.selected_vertex != -1:
			self.vertex_positions[self.selected_vertex] = mouse_position + self.selected_vertex_offset_from_mouse
			self.keep_vertex_inside(self.selected_vertex)
			self.invalidate_edge_crossings_cache()
		
	func left_mouse_clicked() -> void:
		self.selected_vertex = self.get_vertex_at_mouse()
		if self.selected_vertex != -1:
			self.selected_vertex_offset_from_mouse = self.vertex_positions[self.selected_vertex] - mouse_position
			
	func left_mouse_released() -> void:
		self.selected_vertex = -1
		
	func draw(size: Vector2, draw_vertex: Callable, draw_edge: Callable, compute_crossings: bool = true) -> void:
		# Update cached size
		self.size = size
		
		print("Total Edges: " + str(self.get_undirected_edge_list().size()))
		
		# Draw edges first so that they are behind
		if compute_crossings:
			var crossing_edges: Array[Edge] = self.get_crossing_edges()
			print("Crossing Edges: " + str(crossing_edges.size()))
			#assert(self.get_other_edges(crossing_edges).size() + crossing_edges.size() == self.get_undirected_edge_list().size())
			# Draw non-crossing edges first
			for edge: Edge in self.get_other_edges(crossing_edges):
				draw_edge.call(self.get_draw_pos(edge.head.id, size), self.get_draw_pos(edge.tail.id, size), false)
			# Then emphasise the edges that are crossing over others
			for edge: Edge in crossing_edges:
				draw_edge.call(self.get_draw_pos(edge.head.id, size), self.get_draw_pos(edge.tail.id, size), true)
		else:
			for edge: Edge in self.get_undirected_edge_list():
				draw_edge.call(self.get_draw_pos(edge.head.id, size), self.get_draw_pos(edge.tail.id, size))
			
		# Draw vertices second
		for vertex: int in self.vertex_neighbours.keys():
			var state: RearrangeableVertexState
			if self.selected_vertex == vertex:
				state = RearrangeableVertexState.Selected
			elif self.is_hovering_over_vertex(vertex):
				state = RearrangeableVertexState.Hover
			else:
				state = RearrangeableVertexState.Default
			draw_vertex.call(self.get_draw_pos(vertex, size), vertex, state)
	
				
# An edge in a graph (not used in representing graphs, but can be useful in some situations).
# These may be used as directed or undirected edges.
# Feel free to give position information for the vertices.
class Edge:
	var head: PositionedVertex
	var tail: PositionedVertex
	
	func _init(head: PositionedVertex, tail: PositionedVertex) -> void:
		self.head = head
		self.tail = tail
		
	func _to_string() -> String:
		return "(" + str(self.head.id) + ", " + str(self.tail.id) + ")"

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

# Represents how to display a vertex in a rearrangeable graph
enum RearrangeableVertexState {
	Default,
	Hover,
	Selected
}
