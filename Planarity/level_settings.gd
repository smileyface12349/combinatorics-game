extends Node

var num_nodes: int = 8
var edge_chance: float = 0.35

# For demo purposes
var custom_graph: Graphs.Graph

# For progression
var is_challenge: bool = false

# No longer used
var problem_types: int = 0 # 0 = both, 1 = planar, 2 = non-planar
var graph_generation: int = 0 # 0 = random graphs, 1 = extra hard mode
