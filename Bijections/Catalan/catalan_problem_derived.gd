extends CatalanProblem
class_name CatalanProblemDerived

func _init(title: String, description: String, id: int, 
		bijections: Dictionary = {}, representation: String = "", definitions: Array[BijectionDefinition] = []) -> void:
	super(
		title,
		description,
		id,
		bijections,
		representation,
		definitions
	)

func get_path_from_base() -> Array[CatalanProblem]:
	# BFS to base problem (TODO: Upgrade to Dijkstra's on difficulty)
	# Find shortest path to base problem (use the field "bijections" to find adjacent problems)
	var queue: Array[CatalanProblem] = []
	var visited: Array[int] = [self.id]
	var parent: Dictionary = {}
	queue.append(self)
	while queue.size() > 0:
		var current: CatalanProblem = queue.pop_front()
		if current.id == 0:
			break
		for problem_id: int in current.bijections.keys():
			var next_problem: CatalanProblem = CatalanProblems.new().PROBLEMS[problem_id]
			if not visited.has(problem_id):
				queue.append(next_problem)
				visited.append(next_problem.id)
				parent[next_problem.id] = current

	# Check if there is a path to the base problem
	if 0 not in visited:
		print("No path to base problem found")
		return []

	# Backtrack to find the path
	var path: Array[CatalanProblem] = []
	var current_problem: CatalanProblem = CatalanProblems.new().PROBLEMS[0]
	while current_problem != null:
		path.append(current_problem)
		current_problem = parent.get(current_problem.id, null)

	# Return the path
	return path

func generate_elements(size: int) -> Array[BijectionElement]:
	# Get the path from the base problem
	var path: Array[CatalanProblem] = get_path_from_base()
	if path.is_empty():
		return []

	# Initialise the elements to empty
	var elements: Array[BijectionElement] = []

	# Traverse the path to generate the new elements
	for step: int in range(len(path)):
		print("Step " + str(step) + ": " + str(path[step].title))
		print("Elements: " + str(elements))
		# The base problem has everything hardcoded so we just copy these in
		if step == 0:
			elements = path[step].generate_elements(size)
			continue

		# The derived problems are calculated from the step before
		var current_problem: CatalanProblem = path[step]
		var previous_problem: CatalanProblem = path[step - 1]
		var bijection: CatalanBijection = previous_problem.bijections[current_problem.id]
		var new_elements: Array[BijectionElement] = []
		for element: BijectionElement in elements:
			var new_element: BijectionElement = bijection.mapping.call(element)
			new_elements.append(new_element)
		elements = new_elements

	# Return the elements
	return elements

func get_sizes_dict() -> Dictionary:
	# Get the path from the base problem	
	var path: Array[CatalanProblem] = get_path_from_base()
	if path.is_empty():
		return {
			0: [BijectionElement.new("ERROR", 0)],
			1: [BijectionElement.new("ERROR", 0)],
			2: [BijectionElement.new("ERROR", 0)],
			3: [BijectionElement.new("ERROR", 0)],
			4: [BijectionElement.new("ERROR", 0)]
		}

	# Initialise the sizes to empty
	var sizes: Dictionary = {
		0: [],
		1: [],
		2: [],
		3: [],
		4: []
	}

	# Traverse the path to generate the new elements
	for step: int in range(len(path)):
		
		# The base problem has everything hardcoded so we just copy these in
		if step == 0:
			sizes[0] = path[step].size_0
			sizes[1] = path[step].size_1
			sizes[2] = path[step].size_2
			sizes[3] = path[step].size_3
			sizes[4] = path[step].size_4
			continue

		# The derived problems are calculated from the step before
		var current_problem: CatalanProblem = path[step]
		var previous_problem: CatalanProblem = path[step - 1]
		var bijection: CatalanBijection = previous_problem.bijections[current_problem.id]
		for size: int in range(5):
			var new_elements: Array[BijectionElement] = []
			for element: BijectionElement in sizes[size]:
				var new_element: BijectionElement = bijection.mapping.call(element)
				new_elements.append(new_element)
			sizes[size] = new_elements

	# Return them
	return sizes
