class_name BijectionLevel0
extends BijectionLevel

# Tutorial level (it's really easy!)

func _init() -> void:
	super(
		"Binary Strings",
		"Binary Strings",
		"Strings of length n over the alphabet {A, B}",
		"Strings of length n over the alphabet {1, 2}",
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
			1: Bijection.new(
				1,
				[
					BijectionElement.new("A", true, 1),
					BijectionElement.new("B", true, 2),
				],
				[
					BijectionElement.new("1", false, 1),
					BijectionElement.new("2", false, 2),
				]
			),
			2: Bijection.new(
				2,
				[
					BijectionElement.new("AA", true, 1),
					BijectionElement.new("AB", true, 2),
					BijectionElement.new("BA", true, 3),
					BijectionElement.new("BB", true, 4),
				],
				[
					BijectionElement.new("11", false, 1),
					BijectionElement.new("12", false, 2),
					BijectionElement.new("21", false, 3),
					BijectionElement.new("22", false, 4),
				]
			),
			3: Bijection.new(
				3,
				[
					BijectionElement.new("AAA", true, 1),
					BijectionElement.new("AAB", true, 2),
					BijectionElement.new("ABA", true, 3),
					BijectionElement.new("ABB", true, 4),
					BijectionElement.new("BAA", true, 5),
					BijectionElement.new("BAB", true, 6),
					BijectionElement.new("BBA", true, 7),
					BijectionElement.new("BBB", true, 8),
				],
				[
					BijectionElement.new("111", false, 1),
					BijectionElement.new("112", false, 2),
					BijectionElement.new("121", false, 3),
					BijectionElement.new("122", false, 4),
					BijectionElement.new("211", false, 5),
					BijectionElement.new("212", false, 6),
					BijectionElement.new("221", false, 7),
					BijectionElement.new("222", false, 8),
				]
			)
		}
	)
