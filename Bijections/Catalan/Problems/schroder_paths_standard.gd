extends CatalanProblemDerived
class_name CatalanSchroderPaths

func _init() -> void:
    super(
        "Schroder Paths",
        "Schroder Paths of length 2n-2 with no valleys",
        5,
        {
            1: CatalanBijection.new(
                "Each valley becomes a down step followed by an up step, plus an extra up step at the beginning and a down step at the end",
                func to_dyck_path(schroder_path: SchroderPathElement) -> DyckPathElement:
                    var steps: Array[int] = [1]
                    for i: int in range(len(schroder_path.schroder_steps)):
                        if schroder_path.schroder_steps[i] == 0:
                            steps.append(-1)
                            steps.append(1)
                        else:
                            steps.append(schroder_path.schroder_steps[i])
                    steps.append(-1)
                    return DyckPathElement.new(steps, schroder_path.id),
                "TODO",
                2
            ),
            6: CatalanBijection.new(
                "Use the Schroder path as an outline of the top and fill in the house of cards beneath it",
                func to_house_of_cards(schroder_path: SchroderPathElement) -> HouseOfCardsElement:
                    # Make an empty house of cards
                    var levels: Array[Array] = []
                    var bottom_level_size: int = (schroder_path.get_width() + 2) / 2
                    for level_size: int in range(bottom_level_size, 0, -1):
                        var level: Array = []
                        for i: int in range(level_size):
                            level.append(0)
                        levels.append(level)

                    print("Schroder steps: ", schroder_path.schroder_steps)
                    
                    # Fill it in according to the Schroder path
                    var level: int = 0
                    var index: int = 0
                    for step: int in schroder_path.schroder_steps:
                        print("Level: ", level, " Index: ", index, " Step: ", step)
                        # Fill in the top of the path
                        levels[level][index] = 1
                        # Fill in everything diagonally below it
                        var left_point: int = index
                        var right_point: int = index + 1
                        for i: int in range(level - 1, -1, -1):
                            for j: int in range(left_point, right_point):
                                levels[i][j] = 1
                            right_point += 1
                        # Update based on the step
                        if step == 1:
                            level += 1
                        elif step == -1:
                            level -= 1
                            index += 1
                        elif step == 0:
                            index += 1
                    
                    # Fill in the end (not covered by the last step)
                    levels[0][-1] = 1

                    # Return the house of cards
                    return HouseOfCardsElement.new(levels, schroder_path.id),
                "TODO",
                2
            )
        },
        [DefinitionDyckPath.new()]
    )
