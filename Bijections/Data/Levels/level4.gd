class_name BijectionLevel4
extends BijectionLevel

# Integer partitions (odd parts vs self-conjugate)

func _init() -> void:
	super(
		"Integer Partitions",
		"Integer Partitions",
		"Partitions of n into distinct odd parts",
		"Self-conjugate partitions of n",
		{
			0: Bijection.new(
				0,
				# Left elements
				[
					IntegerPartitionElement.new("", [], 1), 
				],
				# Right elements 
				[
					IntegerPartitionElement.new("", [], 1),
				]
			),
		},
		"Try to draw lines across the Ferrer diagram to reinterpret it in a different way"
	)
