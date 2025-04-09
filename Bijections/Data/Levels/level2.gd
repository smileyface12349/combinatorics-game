class_name BijectionLevel2
extends BijectionLevel

# Stars and bars

func _init() -> void:
	super(
		"Object Types",
		"Stars and Bars",
		"Strings of length n over the alphabet {A, B, C} in alphabetical order",
		"Binary strings with 2 1s and n 0s",
		{
			0: Bijection.new(
				0,
				# Left elements
				[
					BijectionElement.new("", 1), 
				],
				# Right elements 
				[
					BijectionElement.new("11", 1),
				]
			),
			1: Bijection.new(
				1,
				# Left elements
				[
					BijectionElement.new("A", 1), 
					BijectionElement.new("B", 2), 
					BijectionElement.new("C", 3), 
				],
				# Right elements 
				[
					BijectionElement.new("011", 1),
					BijectionElement.new("101", 2),
					BijectionElement.new("110", 3),
				]
			),
			2: Bijection.new(
				2,
				# Left elements
				[
					BijectionElement.new("AA", 1), 
					BijectionElement.new("AB", 2), 
					BijectionElement.new("AC", 3), 
					BijectionElement.new("BB", 4), 
					BijectionElement.new("BC", 5), 
					BijectionElement.new("CC", 6), 
				],
				# Right elements 
				[
					BijectionElement.new("0011", 1),
					BijectionElement.new("0101", 2),
					BijectionElement.new("0110", 3),
					BijectionElement.new("1001", 4),
					BijectionElement.new("1010", 5),
					BijectionElement.new("1100", 6),
				]
			),
			3: Bijection.new(
				3,
				# Left elements
				[
					BijectionElement.new("AAA", 1), 
					BijectionElement.new("AAB", 2), 
					BijectionElement.new("AAC", 3), 
					BijectionElement.new("ABB", 4), 
					BijectionElement.new("ABC", 5), 
					BijectionElement.new("ACC", 6), 
					BijectionElement.new("BBB", 7), 
					BijectionElement.new("BBC", 8), 
					BijectionElement.new("BCC", 9), 
					BijectionElement.new("CCC", 10), 
				],
				# Right elements 
				[
					BijectionElement.new("00011", 1), 
					BijectionElement.new("00101", 2), 
					BijectionElement.new("00110", 3), 
					BijectionElement.new("01001", 4), 
					BijectionElement.new("01010", 5), 
					BijectionElement.new("01100", 6), 
					BijectionElement.new("10001", 7), 
					BijectionElement.new("10010", 8), 
					BijectionElement.new("10100", 9), 
					BijectionElement.new("11000", 10), 
				],
			),
		},
		func generate_left (size: int) -> Array[String]:
			return [],
		func generate_right (size: int) -> Array[String]:
			return [],
		"Strings in alphabetical order on {A, B, C} e.g. \"AAB\" or \"ABBCCC\"",
		"Strings on {0, 1} e.g. \"0110\" or \"101010\"",
		[],
		"Think of the binary string as 3 buckets, with the 1s simply being dividers between these buckets"
	)
