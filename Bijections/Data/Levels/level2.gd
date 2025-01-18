class_name BijectionLevel2
extends BijectionLevel

# Stars and bars

func _init() -> void:
	super(
		"Object Types",
		"Stars and Bars",
		"Strings of length n over the alphabet {A, B, C}",
		"Binary strings with 2 1s and n 0s",
		{
			0: Bijection.new(
				0,
				# Left elements
				[
					BijectionElement.new("", true, 1), 
				],
				# Right elements 
				[
					BijectionElement.new("", false, 1),
				]
			),
		}
	)
