class_name BijectionLevel0
extends BijectionLevel

# Tutorial level (it's really easy!)

func _init() -> void:
	super(
		0,
		"Binary Strings",
		"Binary Strings",
		"Strings of length n over the alphabet {A, B}",
		"Strings of length n over the alphabet {1, 2}",
		{
			0: Bijection.new(
				0,
				# Left elements
				[
					BijectionElement.new("", 1), 
				],
				# Right elements 
				[
					BijectionElement.new("", 1),
				]
			),
			1: Bijection.new(
				1,
				[
					BijectionElement.new("A", 1),
					BijectionElement.new("B", 2),
				],
				[
					BijectionElement.new("1", 1),
					BijectionElement.new("2", 2),
				]
			),
			2: Bijection.new(
				2,
				[
					BijectionElement.new("AA", 1),
					BijectionElement.new("AB", 2),
					BijectionElement.new("BA", 3),
					BijectionElement.new("BB", 4),
				],
				[
					BijectionElement.new("11", 1),
					BijectionElement.new("12", 2),
					BijectionElement.new("21", 3),
					BijectionElement.new("22", 4),
				]
			),
			3: Bijection.new(
				3,
				[
					BijectionElement.new("AAA", 1),
					BijectionElement.new("AAB", 2),
					BijectionElement.new("ABA", 3),
					BijectionElement.new("ABB", 4),
					BijectionElement.new("BAA", 5),
					BijectionElement.new("BAB", 6),
					BijectionElement.new("BBA", 7),
					BijectionElement.new("BBB", 8),
				],
				[
					BijectionElement.new("111", 1),
					BijectionElement.new("112", 2),
					BijectionElement.new("121", 3),
					BijectionElement.new("122", 4),
					BijectionElement.new("211", 5),
					BijectionElement.new("212", 6),
					BijectionElement.new("221", 7),
					BijectionElement.new("222", 8),
				]
			)
		},
		func (size: int) -> Array[String]:
			var elements: Array[String] = []
			for bit_string: int in range(2 ** size):
				elements.append(String.num_int64(bit_string, 2).pad_zeros(size).replace("0", "A").replace("1", "B"))
			return elements,
		func (size: int) -> Array[String]:
			var elements: Array[String] = []
			for bit_string: int in range(2 ** size):
				elements.append(String.num_int64(bit_string, 2).pad_zeros(size).replace("0", "2"))
			return elements,
		"Strings on {A, B} e.g. \"AB\" or \"AAB\"",
		"Strings on {1, 2} e.g. \"12\" or \"112\"",
		[],
		"Try substituting A with 1 and B with 2",
		BijectionProof.new("Bijection: Take any item from the LHS and replace A with 1 and B with 2.\n\nProof (Injection): Suppose x and y are binary strings over the alphabet {A, B} and f(x) = f(y). By replacing 1 with A and 2 with B in both of these (inverting the function), we obtain x and y. But since we have done the same thing to both of them, x = y.\nProof (Surjection): Take any element f(x) in the RHS. Replace 1 with A and 2 with B. This x is in the LHS.\n\nProof (Using Invertability): It should be easy to see that this function has a unique inverse (replacing 1 with A and 2 with B). No other inverses are possible. Therefore, it is a bijection.")
	)
