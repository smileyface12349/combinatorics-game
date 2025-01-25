extends BijectionElement
class_name IntegerPartitionElement

var parts: Array[int]

## parts: [number of 1s, number of 2s, number of 3s, ...]
func _init(parts: Array[int], id: int) -> void:
	# Obtain a string representation to use when diagrams are disabled
	var text_pieces: Array[String]
	var number: int = 0
	for occurrences: int in parts:
		number += 1
		if occurrences == 0:
			continue
		elif occurrences == 1:
			text_pieces.append(str(number))
		else:
			text_pieces.append(str(occurrences) + "(" + str(number) + ")")
	var text: String = '+'.join(text_pieces)
	super(text, id)
	self.parts = parts
