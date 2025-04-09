class_name BijectionLevel5
extends BijectionLevel

# Integer partitions (odd parts vs distinct parts)

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
            # 5: Bijection.new(
            # 	5,
            # 	# TODO: Don't fully understand the bijection yet
            # 	# Distinct parts
            # 	[
            # 		IntegerPartitionElement.new([0, 0, 0, 0, 1], 1), # 5
            # 		IntegerPartitionElement.new([1, 0, 0, 1], 2), # 4+1
            # 		IntegerPartitionElement.new([0, 1, 1], 3), # 3+2
            # 	],
            # 	# Odd parts
            # 	[
            # 		IntegerPartitionElement.new([0, 0, 0, 0, 1], 1), # 5
            # 		IntegerPartitionElement.new([2, 0, 1], 2), # 3+2(1)
            # 		IntegerPartitionElement.new([], 3), # 5(1)
            # 	],
            # ),
            7: Bijection.new(
                7,
                # Distinct parts
                [
                    IntegerPartitionElement.new([0, 0, 0, 0, 0, 0, 1], 1), # 7
                    IntegerPartitionElement.new([1, 0, 0, 0, 0, 1], 2), # 6+1
                    IntegerPartitionElement.new([0, 1, 0, 0, 1], 3), # 5+2
                    IntegerPartitionElement.new([0, 0, 1, 1], 4), # 4+3
                    IntegerPartitionElement.new([1, 1, 0, 1], 5), # 4+2+1
                ],
                # Odd parts
                [
                    IntegerPartitionElement.new([0, 0, 0, 0, 0, 0, 1], 1), # 7
                    IntegerPartitionElement.new([2, 0, 0, 0, 1], 2), # 5+2(1)
                    IntegerPartitionElement.new([1, 0, 2], 3), # 2(3)+1
                    IntegerPartitionElement.new([4, 0, 1], 4), # 3+4(1)
                    IntegerPartitionElement.new([7], 4), # 7(1)
                ]
            ),
            # TODO: Rearrange the order so that the bijection is actually correct
            10: Bijection.new(
                10,
                # Distinct parts
                [
                    IntegerPartitionElement.new([0, 0, 0, 0, 0, 0, 0, 0, 0, 1], 1), # 10
                    IntegerPartitionElement.new([1, 0, 0, 0, 0, 0, 0, 0, 1], 2), # 9+1
                    IntegerPartitionElement.new([0, 1, 0, 0, 0, 0, 0, 1], 3), # 8+2
                    IntegerPartitionElement.new([0, 0, 1, 0, 0, 0, 1], 4), # 7+3
                    IntegerPartitionElement.new([1, 1, 0, 0, 0, 0, 1], 5), # 7+2+1
                    IntegerPartitionElement.new([0, 0, 1, 0, 0, 1], 6), # 6+3
                    IntegerPartitionElement.new([1, 1, 0, 0, 0, 1], 7), # 6+2+1
                    IntegerPartitionElement.new([1, 0, 0, 1, 1], 8), # 5+4+1
                    IntegerPartitionElement.new([0, 1, 1, 0, 1], 9), # 5+3+2
                    IntegerPartitionElement.new([1, 1, 1, 1], 10), # 4+3+2+1
                ],
                # Odd parts
                [
                    IntegerPartitionElement.new([1, 0, 0, 0, 0, 0, 0, 0, 1], 1), # 9+1
                    IntegerPartitionElement.new([0, 0, 1, 0, 0, 0, 1], 2), # 7+3
                    IntegerPartitionElement.new([3, 0, 0, 0, 0, 0, 1], 3), # 7+3(1)
                    IntegerPartitionElement.new([0, 0, 0, 0, 2], 4), # 2(5)
                    IntegerPartitionElement.new([2, 0, 1, 0, 1], 5), # 5+3+2(1)
                    IntegerPartitionElement.new([5, 0, 0, 0, 1], 6), # 5+5(1)
                    IntegerPartitionElement.new([1, 0, 3], 7), # 3(3)+1
                    IntegerPartitionElement.new([4, 0, 2], 8), # 2(3)+4(1)
                    IntegerPartitionElement.new([7, 0, 1], 9), # 3+7(1)
                    IntegerPartitionElement.new([10], 10), # 10(1)
                ]
            )
        },
        # THE USER REPRESENTATION IS DIFFERENT - A descending sequence of integers
        func generate_left (size: int) -> Array[Array]:
            var partitions: Array[Array] = []
            for partition: Array[int] in IntegerPartitionElement.generate_partitions(size):
                # Filter out the partitions which have repeating parts
                # OLD FORMAT:
                # for c: int in partition:
                #     if c > 1:
                #         include = false
                #         break
                var include: bool = true
                for i: int in range(1, len(partition)):
                    if partition[i] == partition[i - 1]:
                        print("Filtered out from index ", i, " with value ", partition[i])
                        include = false
                        break
                if include:
                    partitions.append(partition)
            return partitions,
        func generate_right (size: int) -> Array[Array]:
            var partitions: Array[Array] = []
            for partition: Array[int] in IntegerPartitionElement.generate_partitions(size):
                print("Considering partition: ", partition)
                # Filter out the partitions which have even parts
                var include: bool = true
                # OLD FORMAT:
                # for i: int in range(1, len(partition), 2):
                #     if partition[i] != 0:
                #         print("Filtered out from index ", i, " with value ", partition[i])
                #         include = false
                #         break
                for i: int in range(len(partition)):
                    if partition[i] % 2 == 0:
                        print("Filtered out from index ", i, " with value ", partition[i])
                        include = false
                        break
                if include:
                    partitions.append(partition)
            return partitions,
        "An array of integers in descending order representing the parts, e.g. [7, 5, 1] or [11, 9, 1]",
        "An array of integers in descending order representing the parts, e.g. [7, 5, 1] or [5, 3, 3]",
        [
            DefinitionPartition.new()
        ]
    )
