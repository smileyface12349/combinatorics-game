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
		
	# Get number of edges
	func get_edge_count() -> int:
		var edge_count: int = 0
		for vertex: int in self.vertex_neighbours.keys():
			for neighbour: int in self.vertex_neighbours[vertex]:
				if vertex >= neighbour:
					continue
				edge_count += 1
		return edge_count
		
	# Get number of vertices
	func get_vertex_count() -> int:
		return self.vertex_neighbours.keys().size()
		
	# Outputs a graph drawing where all nodes are positioned randomly
	func get_drawing_random(deep_copy: bool = false) -> GraphDrawing:
		var vertex_positions: Dictionary = {}
		for vertex: int in self.vertex_neighbours.keys():
			vertex_positions[vertex] = Vector2(randf(), randf())
		if deep_copy:
			return GraphDrawing.new(vertex_neighbours.duplicate(true), vertex_positions)
		else:
			return GraphDrawing.new(vertex_neighbours, vertex_positions)
		
	# Outputs a graph drawing using the Fruchterman-Reingold algorithm such that nodes are spaced
	# far apart, but also close to their neighbours
	# Keeps going until max time or min amount of total movement, whichever comes first.
	func get_drawing_best(deep_copy: bool = false, max_time: float = 0.1, min_movement: float = 0.01) -> GraphDrawing:
		var drawing: GraphDrawing = self.get_drawing_random(deep_copy)
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
		
	# Deletes a vertex, and all edges incident to it
	func delete_vertex(vertex: int) -> void:
		var neighbours: Array = self.vertex_neighbours[vertex]
		for neighbour: int in neighbours:
			self.vertex_neighbours[neighbour].erase(vertex)
		self.vertex_neighbours.erase(vertex)
		
	# Deletes an edge
	func delete_edge(edge: Edge) -> void:
		self.vertex_neighbours[edge.head.id].erase(edge.tail.id)
		self.vertex_neighbours[edge.tail.id].erase(edge.head.id)
		
	# Contract two vertices
	func contract_vertices(vertex1: int, vertex2: int) -> void:
		# Determine new list of neighbours
		var new_neighbours: Array[int] = []
		
		# For each neighbour of vertex2, replace it with vertex1
		for neighbour: int in self.vertex_neighbours[vertex2]:
			self.vertex_neighbours[neighbour].erase(vertex2)
			if vertex1 not in self.vertex_neighbours[neighbour]:
				self.vertex_neighbours[neighbour].append(vertex1)
				new_neighbours.append(neighbour)
				
		# Remove vertex2
		self.vertex_neighbours.erase(vertex2)
		
		# Add the new neighbours to vertex1
		self.vertex_neighbours[vertex1].append_array(new_neighbours)
	
	
# A graph where each node has a position
class GraphDrawing extends Graph:
	var vertex_positions: Dictionary
	var edge_crossings_cache: Array[Edge]
	var edge_intersections_cache: Array[Vector2]
	var edge_crossings_cache_invalidate: bool
	var edge_intersections_cache_invalidate: bool
	
	func _init(vertex_neighbours: Dictionary = {}, vertex_positions: Dictionary = {}) -> void:
		super(vertex_neighbours)
		self.vertex_positions = vertex_positions
		self.edge_crossings_cache = []
		self.edge_crossings_cache_invalidate = true
		self.edge_intersections_cache_invalidate = true
		
	func get_vertex_info(vertex: int) -> PositionedVertex:
		return PositionedVertex.new(vertex, self.vertex_positions[vertex])
		
	# Gets the full list of edges
	# This will return each edge twice, one for each direction.
	func get_directed_edge_list() -> Array[Edge]:
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
		
	# Gets all the points at which edges intersect with each other
	func get_edge_intersections() -> Array[Vector2]:
		if self.edge_intersections_cache_invalidate:
			self.edge_intersections_cache = self.force_get_edge_intersections()
			self.edge_intersections_cache_invalidate = false
		return self.edge_intersections_cache
		
	func graph_drawing_changed() -> void:
		self.edge_crossings_cache_invalidate = true
		self.edge_intersections_cache_invalidate = true
		self.check_win()
		
	# Override depending on type of graph
	func check_win() -> void:
		pass
		
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
		
	func force_get_edge_intersections() -> Array[Vector2]:
		var vertices: Array[Vector2] = []

		for edge1: Edge in self.get_undirected_edge_list():
			for edge2: Edge in self.get_undirected_edge_list():
				# only consider each pair once
				if not (edge1.head.id < edge2.head.id || (edge1.head.id == edge2.head.id && edge1.tail.id < edge2.tail.id)):
					continue
					
				var intersection: Vector2 = self.get_intersection_point(edge1, edge2)
				if intersection != Vector2(-1, -1):
					vertices.append(intersection)
					
		return vertices
		
	# Gets the intersection point between two edges by solving parametric equations
	# AI DECLARATION: ChatGPT was used in writing this function
	static func get_intersection_point(e1: Edge, e2: Edge) -> Vector2:
		var x1: float = e1.t.p.x
		var y1: float = e1.t.p.y
		var x2: float = e1.h.p.x
		var y2: float = e1.h.p.y
		
		var x3: float = e2.t.p.x
		var y3: float = e2.t.p.y
		var x4: float = e2.h.p.x
		var y4: float = e2.h.p.y

		var denom: float = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
		if abs(denom) < 0.0001:  # Check for parallel lines
			return Vector2(-1, -1)

		var t: float = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom
		var u: float = ((x1 - x3) * (y1 - y2) - (y1 - y3) * (x1 - x2)) / denom

		if (0.00001 <= t && t <= 0.99999) and (0 <= u && u <= 1):
			return Vector2(
				x1 + t * (x2 - x1),
				y1 + t * (y2 - y1)
			)
		return Vector2(-1, -1)
		
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
	static func test_edge_crossing(edge1: Edge, edge2: Edge) -> bool:
		return get_intersection_point(edge1, edge2) != Vector2(-1, -1)
	
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
			
		# Graph changed: invalidate cache
		self.graph_drawing_changed()
			
		# Output total amount of movement (use this to detect convergence)
		var total_force: float = 0
		for force: Vector2 in forces.values(): 
			total_force += force.length()
		return total_force
		
	# Moves the drawing to the center of the page, preserving the shape and distances
	func recenter_drawing() -> void:
		# Determine the bounds
		var x_min: float = 1
		var x_max: float = 0
		var y_min: float = 1
		var y_max: float = 0
		
		for pos: Vector2 in self.vertex_positions.values():
			if pos.x < x_min:
				x_min = pos.x
			if pos.x > x_max:
				x_max = pos.x
			if pos.y < y_min:
				y_min = pos.y
			if pos.y > y_max:
				y_max = pos.y
				
		# Translate and scale each coordinate
		for vertex: int in self.vertex_positions:
			self.vertex_positions[vertex] -= Vector2(x_min, y_min)
			self.vertex_positions[vertex].x /= x_max - x_min
			self.vertex_positions[vertex].y /= y_max - y_min
		
		# We've changed the graph - invalidate the cache
		self.graph_drawing_changed()
	
	# Shrinks the drawing, bringing it naturally closer to the center
	func shrink_drawing(amount: float = 0.1) -> void:
		for vertex: int in self.vertex_positions:
			# Get distance and direction from center
			var distance: float = self.vertex_positions[vertex].distance_to(Vector2(0.5, 0.5))
			var direction: Vector2 = (self.vertex_positions[vertex] - Vector2(0.5, 0.5)).normalized()
			
			# Shrink this distance by the given amount
			distance *= (1-amount)
			
			# Update the new position
			self.vertex_positions[vertex] = Vector2(0.5, 0.5) + direction * distance
			
		# Invalidate cache
		self.graph_drawing_changed()
		
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
			
	# Deletes a vertex, and all edges incident to it
	func delete_vertex(vertex: int) -> void:
		self.vertex_positions.erase(vertex)
		super(vertex)
		self.graph_drawing_changed()
		
	# Contracts two vertices
	func contract_vertices(vertex1: int, vertex2: int) -> void:
		super(vertex1, vertex2)
		self.vertex_positions.erase(vertex2)
		self.graph_drawing_changed()
			
	# Get a rearrangeable version of the graph
	func get_rearrangeable(deep_copy: bool = false) -> RearrangeableGraphDrawing:
		if deep_copy:
			return RearrangeableGraphDrawing.new(self.vertex_neighbours.duplicate(true), self.vertex_positions.duplicate(true))
		else:
			return RearrangeableGraphDrawing.new(self.vertex_neighbours, self.vertex_positions)


# A class to handle a graph that can be rearranged by the user. Don't forget to keep it updated
# with the current mouse position and any mouse clicks!
class RearrangeableGraphDrawing extends GraphDrawing:
	var selected_vertex: int
	var selected_vertex_offset_from_mouse: Vector2
	var mouse_position: Vector2
	var size: Vector2
	var on_win: Callable
	var has_won: bool # only need to call the win function once. cannot undo a win
	
	func _init(vertex_neighbours: Dictionary = {}, vertex_positions: Dictionary = {}, on_win: Callable = Callable()) -> void:
		super(vertex_neighbours, vertex_positions)
		self.selected_vertex = -1
		self.mouse_position = Vector2(0, 0)
		self.size = Vector2(0, 0)
		self.on_win = on_win
		self.has_won = false
		
	# Resize the drawing. This can instead be done when calling draw().
	func resize(new_size: Vector2) -> void:
		self.size = new_size
		
	# Check for win
	func check_win() -> void:
		if not self.has_won and self.get_crossing_edges().is_empty():
			self.on_win.call()
			self.has_won = true
	
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
		
	func get_other_vertex_at_mouse(exclude_vertex: int) -> int:
		for vertex: int in self.vertex_positions.keys():
			if vertex == exclude_vertex:
				continue
			if self.is_hovering_over_vertex(vertex):
				return vertex
		return -1
		
	func is_hovering_over_edge(edge: Edge, distance_to_edge: float = 4) -> bool:
		# If we're also hovering over a vertex, then don't hover over any edges
		# TODO: This could be more efficient
		if self.get_vertex_at_mouse() != -1:
			return false
		
		# Get necessary variables, all in vertex coordinates
		var line_segment: Vector2 = edge.tail.position - edge.head.position
		var head_to_point: Vector2 = self.mouse_position - edge.head.position
		
		# Project point onto line using a dot product
		var t: float = clamp(head_to_point.dot(line_segment) / line_segment.length_squared(), 0, 1)
		var closest_point: Vector2 = edge.head.position + t * line_segment
		
		# Convert to world coordinates so we can test a pixel value instead of relative to graph size
		var mouse_pos: Vector2 = self.vertex_to_world(self.mouse_position, self.size)
		var closest: Vector2 = self.vertex_to_world(closest_point, self.size)
		
		# Determine if the closest point is close enough
		return mouse_pos.distance_to(closest) <= distance_to_edge
		
	func get_edge_at_mouse() -> Edge:
		for edge: Edge in self.get_undirected_edge_list():
			if self.is_hovering_over_edge(edge):
				return edge
		return null
		
	func is_vertex_intersecting_with(vertex1: int, vertex2: int, vertex_radius: float = 10) -> bool:
		return self.get_draw_pos(vertex1, self.size).distance_to(self.get_draw_pos(vertex2, self.size)) <= vertex_radius
		
	func is_vertex_intersecting_with_any(vertex: int, vertex_radius: float = 10) -> bool:
		for vertex2: int in self.vertex_neighbours.keys():
			if vertex2 == vertex:
				continue
			if self.is_vertex_intersecting_with(vertex, vertex2, vertex_radius):
				return true
		return false
		
	func mouse_moved(new_position: Vector2) -> void:
		self.mouse_position = new_position
		if self.selected_vertex != -1:
			self.vertex_positions[self.selected_vertex] = mouse_position + self.selected_vertex_offset_from_mouse
			self.keep_vertex_inside(self.selected_vertex)
			self.graph_drawing_changed()
		
	func left_mouse_clicked() -> void:
		self.selected_vertex = self.get_vertex_at_mouse()
		if self.selected_vertex != -1:
			self.selected_vertex_offset_from_mouse = self.vertex_positions[self.selected_vertex] - mouse_position
			
	func left_mouse_released() -> void:
		self.selected_vertex = -1
		
	func right_mouse_clicked() -> void:
		pass # only used for stuff with graph minors
		
	func right_mouse_released() -> void:
		pass # unused
		
	func draw_rearrangeable(size: Vector2, draw_vertex: Callable, draw_edge: Callable, draw_edge_intersection: Callable) -> void:
		# Update cached size
		self.size = size
		
		# Draw edges first so that they are behind
		var crossing_edges: Array[Edge] = self.get_crossing_edges()
		#(self.get_other_edges(crossing_edges).size() + crossing_edges.size() == self.get_undirected_edge_list().size())
		# Draw non-crossing edges first
		for edge: Edge in self.get_other_edges(crossing_edges):
			draw_edge.call(self.get_draw_pos(edge.head.id, size), self.get_draw_pos(edge.tail.id, size), false)
		# Then emphasise the edges that are crossing over others
		for edge: Edge in crossing_edges:
			draw_edge.call(self.get_draw_pos(edge.head.id, size), self.get_draw_pos(edge.tail.id, size), true)
			
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
		
		# Draw edge intersections
		for crossing_vertex: Vector2 in self.get_edge_intersections():
			draw_edge_intersection.call(self.vertex_to_world(crossing_vertex, size))
	
	func get_minor_rearrangeable(deep_copy: bool = false, on_win: Callable = Callable()) -> MinorRearrangeableGraphDrawing:
		if deep_copy:
			return MinorRearrangeableGraphDrawing.new(self.vertex_neighbours.duplicate(true), self.vertex_positions.duplicate(true), on_win)
		else:
			return MinorRearrangeableGraphDrawing.new(self.vertex_neighbours, self.vertex_positions, on_win)
	
class MinorRearrangeableGraphDrawing extends RearrangeableGraphDrawing:
	# A rearrangeable graph that also supports vertex and edge deletions using right click, and
	# vertex contractions by dragging vertices on top of each other
	
	func _init(vertex_neighbours: Dictionary = {}, vertex_positions: Dictionary = {}, on_win: Callable = Callable()) -> void:
		super(vertex_neighbours, vertex_positions, on_win)
		
	# Check for win
	func check_win() -> void:
		if self.has_won:
			return
			
		var num_vertices: int = self.get_vertex_count()
		var num_edges: int = self.get_edge_count()
		
		# Check if it's a K_5
		if (num_vertices == 5 and num_edges == 10):
			# We don't need to check how the vertices are matched up, there's no other way to do it
			self.on_win.call()
			self.has_won = true
			
		# Check if it's a K_33
		if num_vertices == 6 and num_edges == 9:
			# Choose a vertex arbitrarily to deduce the second set
			var vertex1: int = self.vertex_neighbours.keys()[0]
			var set2: Array[int] = self.vertex_neighbours[vertex1]
			if set2.size() == 3:
				# check that every vertex in set 2 points to a vertex in set 1 (i.e. check for bipartite)
				var win: bool = true
				for vertex: int in set2:
					for neighbour: int in set2:
						win = false
						break
					if not win:
						break
				if win:
					self.on_win.call()
					self.has_won = true
		
	func right_mouse_clicked() -> void:
		# Delete vertex if clicked on
		var vertex_to_delete: int = self.get_vertex_at_mouse()
		if vertex_to_delete != -1:
			self.delete_vertex(vertex_to_delete)
			return
			
		# Delete edge if clicked on
		var edge_to_delete: Edge = self.get_edge_at_mouse()
		if edge_to_delete != null:
			self.delete_edge(edge_to_delete)
		
	func right_mouse_released() -> void:
		pass # don't actually care right now
		
	# Handle edge contractions when left mouse released
	func left_mouse_released() -> void:
		var other_vertex: int = self.get_other_vertex_at_mouse(self.selected_vertex)
		if other_vertex != -1:
			# Contract selected vertex and the other vertex
			self.contract_vertices(other_vertex, self.selected_vertex)
		super()
		
	func draw_rearrangeable(size: Vector2, draw_vertex: Callable, draw_edge: Callable, draw_edge_intersection: Callable) -> void:
		# Update cached size
		self.size = size

		# We don't care about what's crossing over any more
		for edge: Edge in self.get_undirected_edge_list():
			draw_edge.call(self.get_draw_pos(edge.head.id, size), self.get_draw_pos(edge.tail.id, size), false)
		# Now draw the edge (if any) that is being hovered over. Drawing this twice is fine, but could be changed in future.
		var hover_edge: Edge = self.get_edge_at_mouse()
		if hover_edge != null:
			draw_edge.call(self.get_draw_pos(hover_edge.head.id, size), self.get_draw_pos(hover_edge.tail.id, size), true)
			
		# Draw vertices second
		for vertex: int in self.vertex_neighbours.keys():
			var state: RearrangeableVertexState
			if self.selected_vertex == vertex:
				if self.get_other_vertex_at_mouse(vertex) != -1:
					state = RearrangeableVertexState.Contract
				else:
					state = RearrangeableVertexState.Selected
			elif self.is_hovering_over_vertex(vertex):
				if self.selected_vertex != -1:
					state = RearrangeableVertexState.Contract
				else:
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
	
	# Shorthand
	var h: PositionedVertex:
		get:
			return head
	var t: PositionedVertex:
		get:
			return tail
	
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
	
	# Shorthand
	var p: Vector2:
		get:
			return position
	
	func _init(id: int, position: Vector2) -> void:
		super(id)
		self.position = position

# Represents how to display a vertex in a rearrangeable graph
enum RearrangeableVertexState {
	Default,
	Hover,
	Selected,
	Contract
}
