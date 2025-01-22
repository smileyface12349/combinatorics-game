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
					BijectionElement.new("11", false, 1),
				]
			),
			1: Bijection.new(
				1,
				# Left elements
				[
					BijectionElement.new("A", true, 1), 
					BijectionElement.new("B", true, 2), 
					BijectionElement.new("C", true, 3), 
				],
				# Right elements 
				[
					BijectionElement.new("011", false, 1),
					BijectionElement.new("101", false, 2),
					BijectionElement.new("110", false, 3),
				]
			),
			2: Bijection.new(
				2,
				# Left elements
				[
					BijectionElement.new("AA", true, 1), 
					BijectionElement.new("AB", true, 2), 
					BijectionElement.new("AC", true, 3), 
					BijectionElement.new("BA", true, 4),
					BijectionElement.new("BB", true, 5), 
					BijectionElement.new("BC", true, 6), 
					BijectionElement.new("CA", true, 7), 
					BijectionElement.new("CB", true, 8), 
					BijectionElement.new("CC", true, 9), 
				],
				# Right elements 
				[
					BijectionElement.new("0011", false, 1),
					BijectionElement.new("0101", false, 2),
					BijectionElement.new("0110", false, 3),
					BijectionElement.new("0101", false, 1),
					BijectionElement.new("1001", false, 2),
					BijectionElement.new("1010", false, 3),
					BijectionElement.new("0110", false, 1),
					BijectionElement.new("1010", false, 2),
					BijectionElement.new("1100", false, 3),
				]
			),
		},
		"Think of the binary string as 3 buckets, with the 1s simply being dividers between these buckets"
	)
