extends CatalanProblemDerived
class_name CatalanMotzkinPathsColoured

func _init() -> void:
    super(
        "Motzkin Paths",
        "Motzkin Paths of length n-1 with the flat steps coloured red or blue",
        4,
		{
			1: CatalanBijection.new(
				"Map U to UU, D to DD, red _ to UD, blue _ to DU, and add an extra U at the beginning and D at the end",
				func to_dyck_path(motzkin_path: MotzkinPathElement) -> DyckPathElement:
                    var steps: Array[int] = [1]
                    for i: int in range(len(motzkin_path.steps)):
                        if motzkin_path.steps[i] == 0:
                            if motzkin_path.colours[i] == 1:
                                steps.append(1)
                                steps.append(-1)
                            elif motzkin_path.colours[i] == 2:
                                steps.append(-1)
                                steps.append(1)
                        else:
                            steps.append(motzkin_path.steps[i])
                    steps.append(-1)
                    return DyckPathElement.new(steps, motzkin_path.id),
				"TODO",
				2
			)
		},
		[DefinitionDyckPath.new()]
	)
