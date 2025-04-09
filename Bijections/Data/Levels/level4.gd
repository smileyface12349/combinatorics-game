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
		func generate_left (size: int) -> Array[Array]:
			var partitions: Array[Array] = []
			for partition: Array[int] in IntegerPartitionElement.generate_partitions(size):
				# Filter out the partitions which have repeating parts or even parts
				var include: bool = true
				for i: int in range(len(partition)):
					if i > 0 and partition[i] == partition[i - 1]:
						include = false
						break
					if partition[i] % 2 == 0:
						include = false
						break
				if include:
					partitions.append(partition)
			return partitions,
		func generate_right (size: int) -> Array[Array]:
			var partitions: Array[Array] = []
			for partition: Array[int] in IntegerPartitionElement.generate_partitions(size):
				#print("Considering partition: ", partition)
				# Get elements and multiplicities (to make it easier to work with)
				var elements: Array[int] = []
				var multiplicities: Array[int] = []
				# OLD FORMAT:
				# for i: int in range(len(partition)):
				#     if partition[i] > 0:
				#         elements.append(i + 1)
				#         multiplicities.append(partition[i])
				for part: int in partition:
					if part in elements:
						multiplicities[elements.find(part)] += 1
					else:
						elements.append(part)
						multiplicities.append(1)
				
				# Determine if it is self-conjugate
				var include: bool = true
				for i: int in range(len(elements)):
					# Test if element i is equal to the sum of the first i multiplicities
					var sum: int = 0
					for j: int in range(i+1):
						sum += multiplicities[j]
					if elements[elements.size()-i-1] != sum:
						# print("Filtered out from index ", i, " as the sum is ", sum, " and the element is ", elements[elements.size()-i-1])
						include = false
						break
				
				# Include if it's self-conjugate
				if include:
					partitions.append(partition)
			# Return the partitions
			return partitions,
		"An array of integers in descending order representing the parts, e.g. [7, 5, 1] or [11, 9, 1]",
		"An array of integers in descending order representing the parts, e.g. [4, 3, 2, 1] or [6, 6, 3, 2, 2]",
		[
			DefinitionSelfConjugate.new(),
			DefinitionPartition.new(),
		],
		"Try to draw lines across the Ferrer diagram to reinterpret it in a different way"
	)
