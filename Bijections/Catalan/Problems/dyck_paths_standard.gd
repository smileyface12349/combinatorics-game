extends CatalanProblemDerived
class_name CatalanDyckPaths

func _init() -> void:
	super(
		"Dyck Paths",
		"Dyck Paths of length 2n",
		1,
		# [
		# 	DyckPathElement.new([], 1)
		# ],
		# [
		# 	DyckPathElement.new([1, -1], 1)
		# ],
		# [
		# 	DyckPathElement.new([1, 1, -1, -1], 1),
		# 	DyckPathElement.new([1, -1, 1, -1], 2)
		# ],
		# [
		# 	DyckPathElement.new([1, 1, 1, -1, -1, -1], 1),
		# 	DyckPathElement.new([1, 1, -1, 1, -1, -1], 2),
		# 	DyckPathElement.new([1, 1, -1, -1, 1, -1], 3),
		# 	DyckPathElement.new([1, -1, 1, 1, -1, -1], 4),
		# 	DyckPathElement.new([1, -1, 1, -1, 1, -1], 5),
		# ],
		# [
		# 	DyckPathElement.new([1, 1, 1, 1, -1, -1, -1, -1], 1),
		# 	DyckPathElement.new([1, 1, 1, -1, 1, -1, -1, -1], 2),
		# 	DyckPathElement.new([1, 1, 1, -1, -1, 1, -1, -1], 3),
		# 	DyckPathElement.new([1, 1, -1, 1, 1, -1, -1, -1], 4),
		# 	DyckPathElement.new([1, 1, 1, -1, -1, -1, 1, -1], 5),
		# 	DyckPathElement.new([1, -1, 1, 1, 1, -1, -1, -1], 6),
		# 	DyckPathElement.new([1, 1, -1, 1, -1, -1, 1, -1], 7),
		# 	DyckPathElement.new([1, 1, -1, -1, 1, 1, -1, -1], 8),
		# 	DyckPathElement.new([1, -1, 1, 1, -1, 1, -1, -1], 9),
		# 	DyckPathElement.new([1, -1, 1, 1, 1, -1, -1, -1], 10),
		# 	DyckPathElement.new([1, -1, 1, 1, -1, 1, -1, -1], 11),
		# 	DyckPathElement.new([1, -1, 1, 1, -1, -1, 1, -1], 12),
		# 	DyckPathElement.new([1, -1, 1, -1, 1, 1, -1, -1], 13),
		# 	DyckPathElement.new([1, -1, 1, -1, 1, -1, 1, -1], 14),
		# ],
		{
			0: CatalanBijection.new(
				"Map ( to an up walk and ) to a down walk",
				func to_balanced_parentheses(dyck_path: DyckPathElement) -> BijectionElement:
					var parentheses: String = ""
					for c: int in dyck_path.steps:
						if c == 1:
							parentheses += "("
						else:
							parentheses += ")"
					return BijectionElement.new(parentheses, dyck_path.id),
				"Trivial",
				0
			),
			4: CatalanBijection.new(
				"Map UU to U, DD to D, UD to red _, DU to blue _, and remove a U from the beginning and a D from the end",
				func to_motzkin_path(dyck_path: DyckPathElement) -> MotzkinPathElement:
					if len(dyck_path.steps) < 2:
						return MotzkinPathElement.new([], [], dyck_path.id)
					var steps: Array[int] = []
					var colours: Array[int] = []
					for i: int in range(1, len(dyck_path.steps)-1, 2):
						if dyck_path.steps[i] == 1 and dyck_path.steps[i+1] == 1:
							steps.append(1)
							colours.append(0)
						elif dyck_path.steps[i] == -1 and dyck_path.steps[i+1] == -1:
							steps.append(-1)
							colours.append(0)
						elif dyck_path.steps[i] == 1 and dyck_path.steps[i+1] == -1:
							steps.append(0)
							colours.append(1)
						elif dyck_path.steps[i] == -1 and dyck_path.steps[i+1] == 1:
							steps.append(0)
							colours.append(2)
					print("Old steps: ", dyck_path.steps)
					print("New steps: ", steps)
					print("New colours: ", colours)
					assert(len(steps) == len(colours))
					return MotzkinPathElement.new(steps, colours, dyck_path.id),
				"TODO",
				2
			),
			5: CatalanBijection.new(
				"Each down step followed by an up step becomes a flat steps, and we ignore the first up step and last down step.",
				func to_schroder_path(dyck_path: DyckPathElement) -> SchroderPathElement:
					if len(dyck_path.steps) < 2:
						return SchroderPathElement.new([], dyck_path.id)
					var steps: Array[int] = []
					for i: int in range(1, len(dyck_path.steps)-1):
						if dyck_path.steps[i] == 1 and dyck_path.steps[i-1] == -1:
							steps.pop_back()
							steps.append(0)
						else:
							steps.append(dyck_path.steps[i])
					print("Old steps: ", dyck_path.steps)
					print("New steps: ", steps)
					return SchroderPathElement.new(steps, dyck_path.id),
				"TODO",
				2
			)
		},
		"An array of integers 1 (up) or -1 (down), e.g. [1, -1, 1, -1] or [1, 1, -1, -1]",
		[DefinitionDyckPath.new()]
	)
