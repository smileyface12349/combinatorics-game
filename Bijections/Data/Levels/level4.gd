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
			1: Bijection.new(
				1,
				# Left elements
				[
					IntegerPartitionElement.new([1], 1), 
				],
				# Right elements 
				[
					IntegerPartitionElement.new([1], 1),
				]
			),
			2: Bijection.new(
				2,
				# There aren't any for n=2
				[],
				[]
			),
			3: Bijection.new(
				3,
				# Left elements
				[
					IntegerPartitionElement.new([0, 0, 1], 1), # 3
				],
				# Right elements 
				[
					IntegerPartitionElement.new([1, 1], 1), # 2+1
				]
			),
			4: Bijection.new(
				4,
				[
					IntegerPartitionElement.new([1, 0, 1], 1) # 3+1
				],
				[
					IntegerPartitionElement.new([0, 2], 1) # 2(2)
				]
			),
			#5: Bijection.new(
				#5,
				#[
					#IntegerPartitionElement.new([0, 0, 0, 0, 1], 1) # 5
				#],
				#[
					#IntegerPartitionElement.new([2, 0, 1], 1) # 3 + 2(1)
				#]
			#),
			#6: Bijection.new(
				#6,
				#[
					#IntegerPartitionElement.new([1, 0, 0, 0, 1], 1), # 5+1
				#],
				#[
					#IntegerPartitionElement.new([1, 1, 1], 1) # 3+2+1
				#]
			#),
			7: Bijection.new(
				7,
				[
					IntegerPartitionElement.new([0, 0, 0, 0, 0, 0, 1], 1), # 7
				],
				[
					IntegerPartitionElement.new([3, 0, 0, 1], 1), # 4+3(1)
				]
			),
			#8: Bijection.new(
				#8,
				#[
					#IntegerPartitionElement.new([1, 0, 0, 0, 0, 0, 1], 1), # 7+1
					#IntegerPartitionElement.new([0, 0, 1, 0, 1], 2), # 5+3
				#],
				#[
					#IntegerPartitionElement.new([3, 1, 0, 1], 1), # 4+2+3(1)
					#IntegerPartitionElement.new([0, 1, 2], 2) # 2(3)+2
				#]
			#),
			#9: Bijection.new(
				#9,
				#[
					#IntegerPartitionElement.new([0, 0, 0, 0, 0, 0, 0, 0, 1], 1), # 9
					#IntegerPartitionElement.new([1, 0, 1, 0, 1], 2), # 5+3+1
				#],
				#[
					#IntegerPartitionElement.new([3, 1, 0, 1], 1), # 5+4(1)
					#IntegerPartitionElement.new([0, 0, 1], 2) # 3(3)
				#]
			#),
			10: Bijection.new(
				10,
				[
					IntegerPartitionElement.new([1, 0, 0, 0, 0, 0, 0, 0, 1], 1), # 9+1
					IntegerPartitionElement.new([0, 0, 1, 0, 0, 0, 1], 2), # 7+3
				],
				[
					IntegerPartitionElement.new([3, 1, 0, 0, 1], 1), # 5+2+3(1)
					IntegerPartitionElement.new([1, 1, 1, 1], 2) # 4+3+2+1
				]
			),
			13: Bijection.new(
				13,
				[
					IntegerPartitionElement.new([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], 1), # 13
					IntegerPartitionElement.new([1, 0, 1, 0, 0, 0, 0, 0, 1], 2), # 9+3+1
					IntegerPartitionElement.new([1, 0, 0, 0, 1, 0, 1], 3), # 7+5+1
				],
				[
					IntegerPartitionElement.new([6, 0, 0, 0, 0, 0, 1], 1), # 7+6(1)
					IntegerPartitionElement.new([2, 0, 2, 0, 1], 2), # 5+2(3)+2(1)
					IntegerPartitionElement.new([0, 1, 1, 2], 3), # 2(4)+3+2
				],
			),
			16: Bijection.new(
				16,
				[
					IntegerPartitionElement.new([1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], 1), # 15+1
					IntegerPartitionElement.new([0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], 2), # 13+3
					IntegerPartitionElement.new([0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1], 3), # 11+5
					IntegerPartitionElement.new([1, 0, 1, 0, 0, 0, 0, 0, 1], 4), # 9+3+1
				],
				[
					IntegerPartitionElement.new([6, 1, 0, 0, 0, 0, 0, 1], 1), # 8+2+6(1)
					IntegerPartitionElement.new([4, 1, 1, 0, 0, 0, 1], 2), # 7+3+2+4(1)
					IntegerPartitionElement.new([2, 2, 0, 1, 0, 1], 3), # 6+4+2(2)+2(1)
					IntegerPartitionElement.new([2, 0, 2, 0, 1], 4), # 5+2(3)+2(1)
				],
			),
			21: Bijection.new(
				21,
				[
					IntegerPartitionElement.new([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], 1), # 21
					IntegerPartitionElement.new([1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], 2), # 17+3+1
					IntegerPartitionElement.new([1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], 3), # 15+5+1
					IntegerPartitionElement.new([0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1], 4), # 13+5+3
					IntegerPartitionElement.new([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1], 5), # 13+7+1
					IntegerPartitionElement.new([1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1], 6), # 11+9+1
					IntegerPartitionElement.new([0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1], 7), # 11+7+3
					IntegerPartitionElement.new([0, 0, 0, 0, 1, 0, 1, 0, 1], 8), # 9+7+5
				],
				[
					IntegerPartitionElement.new([10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], 1), # 11+10(1)
					IntegerPartitionElement.new([6, 0, 2, 0, 0, 0, 0, 1], 2), # 8+2(3)+6(1)
					IntegerPartitionElement.new([4, 1, 1, 1, 0, 0, 0, 1], 3), # 8+4+3+2+4(1)
					IntegerPartitionElement.new([3, 0, 1, 2, 0, 0, 1], 4), # 7+2(4)+3+3(1)
					IntegerPartitionElement.new([2, 2, 1, 0, 1, 0, 1], 5), # 7+5+3+2(2)+2(1)
					IntegerPartitionElement.new([0, 2, 1, 0, 0, 2], 6), # 2(6)+3+2(2)
					IntegerPartitionElement.new([1, 1, 1, 1, 1, 1], 7), # 6+5+4+3+2+1
					IntegerPartitionElement.new([0, 0, 2, 0, 3], 8), # 3(5)+2(3)
				],
			)
		},
		[
			DefinitionSelfConjugate.new(),
			DefinitionPartition.new(),
		],
		"Try to draw lines across the Ferrer diagram to reinterpret it in a different way"
	)
