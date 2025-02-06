extends CatalanProblem
class_name CatalanParentheses

func _init() -> void:
	super(
		"Parentheses",
		"Sequences of n opening and n closing parentheses which are balanced",
		0,
		[
			BijectionElement.new("", 1)
		],
		[
			BijectionElement.new("()", 1)
		],
		[
			BijectionElement.new("(())", 1),
			BijectionElement.new("()()", 2)
		],
		[],
		[],
		{
			1: BijectionProof.new(
				"Bijection: Map ( to an up walk and ) to a down walk.\n\nProof: Trivial",
				0
			)
		},
		[DefinitionBalancedParentheses.new()]
	)
