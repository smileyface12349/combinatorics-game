class_name BijectionLevel3
extends BijectionLevel

# Stars and bars

func _init() -> void:
	super(
		2,
		"Permutations",
		"Tableaux Pairs",
		"Permutations of {1, ..., n}",
		"Pairs of Young Tableaux of size n",
		{
			1: Bijection.new(
                1,
                # Left elements
                [
                    BijectionElement.new("1", 1), 
                ],
                # Right elements 
                [
                    TableauxPairElement.new([[1]], [[1]], 1),
                ]
            ),
            2: Bijection.new(
                2,
                # Left elements
                [
                    BijectionElement.new("12", 1), 
                    BijectionElement.new("21", 2), 
                ],
                # Right elements 
                [
                    TableauxPairElement.new([[1, 2]], [[1, 2]], 1),
                    TableauxPairElement.new([[1], [2]], [[1], [2]], 2),
                ]
            ),
            3: Bijection.new(
                3,
                # Left elements
                [
                    BijectionElement.new("123", 1), 
                    BijectionElement.new("132", 2), 
                    BijectionElement.new("213", 3), 
                    BijectionElement.new("231", 4), 
                    BijectionElement.new("312", 5), 
                    BijectionElement.new("321", 6), 
                ],
                # Right elements 
                [
                    TableauxPairElement.new([[1, 2, 3]], [[1, 2, 3]], 1),
                    TableauxPairElement.new([[1, 2], [3]], [[1, 2], [3]], 2),
                    TableauxPairElement.new([[1, 3], [2]], [[1, 3], [2]], 3),
                    TableauxPairElement.new([[1, 3], [2]], [[1, 2], [3]], 4),
                    TableauxPairElement.new([[1, 2], [3]], [[1, 3], [2]], 5),
                    TableauxPairElement.new([[1], [2], [3]], [[1], [2], [3]], 6),
                ]
            )
		},
		func generate_left (size: int) -> Array[String]:
			return [],
		func generate_right (size: int) -> Array[String]:
			return [],
		"Strings on {1, ..., n} e.g. \"123\" or \"321\"",
		"An array of [first, second], where each is an array of rows, each row is an array of integers.",
		[
            DefinitionTableau.new(),
            DefinitionTableauPair.new(),
        ],
		"Try to build a tableau by adding elements in order and bumping down elements where necessary. The other one is formed by keeping track of which order they were added in."
	)
