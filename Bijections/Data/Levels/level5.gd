class_name BijectionLevel5
extends BijectionLevel

# Integer partitions (odd parts vs self-conjugate)

func _init() -> void:
	super(
		"Integer Partitions",
		"Integer Partitions",
		"Partitions of n into distinct parts",
		"Partitions of n into odd parts",
		{
			1: Bijection.new(
				1,
				# Distinct parts
				[
					IntegerPartitionElement.new([1], 1), 
				],
				# Odd parts
				[
					IntegerPartitionElement.new([1], 1),
				]
			),
			2: Bijection.new(
				2,
				# Distinct parts
				[
					IntegerPartitionElement.new([0, 1], 1), # 2
				],
				# Odd parts
				[
					IntegerPartitionElement.new([2], 1), # 1+1
				]
			),
			3: Bijection.new(
				3,
				# Distinct parts
				[
					IntegerPartitionElement.new([0, 0, 1], 1), # 3
					IntegerPartitionElement.new([1, 1], 2), # 1+2
				],
				# Odd parts
				[
					IntegerPartitionElement.new([0, 0, 1], 1), # 3
					IntegerPartitionElement.new([3], 2), # 3(1)
				]
			),
			4: Bijection.new(
				4,
				# Distinct parts
				[
					IntegerPartitionElement.new([0, 0, 0, 1], 1), # 4
					IntegerPartitionElement.new([1, 0, 0, 1], 2), # 3+1
				],
				# Odd parts
				[
					IntegerPartitionElement.new([1, 0, 1], 1), # 3+1
					IntegerPartitionElement.new([4], 2), # 4(1)
				]
			),
			5: Bijection.new(
				5,
				# TODO: Don't fully understand the bijection yet
				# Distinct parts
				[
					IntegerPartitionElement.new([0, 0, 0, 0, 1], 1), # 5
					IntegerPartitionElement.new([1, 0, 0, 1], 2), # 4+1
					IntegerPartitionElement.new([0, 1, 1], 3), # 3+2
				],
				# Odd parts
				[
					IntegerPartitionElement.new([0, 0, 0, 0, 1], 1), # 5
					IntegerPartitionElement.new([2, 0, 1], 2), # 3+2(1)
					IntegerPartitionElement.new([], 3), # 5(1)
				],
			),
		},
		func generate_left (size: int) -> Array[Array]:
			return [],
		func generate_right (size: int) -> Array[Array]:
			return [],
		[
			DefinitionPartition.new()
		]
	)
