class_name BijectionLevelTest
extends BijectionLevel

# Test level
# Put whatever you want in here - the user won't see it

func _init() -> void:
	super(
		-1,
		"A Very Long Title",
		"ééééééééééé",
		"A really really complicated description of something that actually isn't that complicated",
		":-)",
		{
			0: Bijection.new(
				0,
				# Left elements
				[
					DyckPathElement.new([], 1), 
				],
				# Right elements 
				[
					BinaryTreeElement.new([0, 0], 1),
				]
			),
			1: Bijection.new(
				1,
				# Left elements
				[
					DyckPathElement.new([1, -1], 1), 
					BijectionElement.new("Orange", 2),
				],
				# Right elements 
				[
					BinaryTreeElement.new([[0, 0], [0, 0]], 1),
					BijectionElement.new("Apple", 2)
				]
			),
		},
		func left_generator(size: int) -> Array:
			var element: Array = []
			for i: int in range(size):
				element.append(1)
			return element,
		func right_generator(size: int) -> Array:
			var element: Array = []
			for i: int in range(size):
				element.append(1)
			return element,
		"Left representation",
		"Right representation",
		[],
		"You're stupid",
		BijectionProof.new("Proof by Assumption: Assume that it is a bijection. Therefore it is a bijection. QED.")
	)
