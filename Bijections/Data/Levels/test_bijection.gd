class_name BijectionLevelTest
extends BijectionLevel

# Test level
# Put whatever you want in here - the user won't see it

func _init() -> void:
	super(
		"A Very Very Long Title",
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
					BijectionElement.new("", 1),
				]
			),
			1: Bijection.new(
				1,
				# Left elements
				[
					DyckPathElement.new([1, -1], 1), 
				],
				# Right elements 
				[
					BijectionElement.new("()", 1),
				]
			),
		},
		"You're stupid",
		BijectionProof.new("Proof by Assumption: Assume that it is a bijection. Therefore it is a bijection. QED.")
	)
