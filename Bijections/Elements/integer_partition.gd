extends BijectionElement
class_name IntegerPartitionElement

var parts: Array[int]

## parts: [number of 1s, number of 2s, number of 3s, ...]
## Constraint: Must not contain trailing zeroes
func _init(parts: Array[int], id: int) -> void:
	self.parts = parts
	# Obtain a string representation to use when diagrams are disabled
	var text_pieces: Array[String]
	self.for_each_part(func add_text(num: int, count: int) -> void:
		if count == 1:
			text_pieces.append(str(num))
		else:
			text_pieces.append(str(count) + "(" + str(num) + ")")
	)
		
	var text: String = '+'.join(text_pieces)
	super(text, id)

## Gets the largest part. For example, 1+2(5) would return 5.
## WARNING: This assumes the list has no trailing zeroes.
func get_largest_part() -> int:
	return len(self.parts)
	
## Gets the total number of parts. For example, 1+2(5) would return 3.
func count_parts() -> int:
	var total: int = 0
	#self.for_each_part(func add_to_total(num: int, count: int) -> void:
		#total += count
	#)
	for occurrences: int in self.parts:
		total += occurrences
	return total
	
func get_code_representation() -> Variant:
	return parts


## Iterates through every part with a non-zero number of occurrences in descending order, and calls
## the function. For example, 1+2(5) would call with (5, 2) then call with (1, 1)
func for_each_part(action: Callable) -> void:
	for number: int in range(len(self.parts), 0, -1):
		if self.parts[number-1] != 0:
			action.call(number, self.parts[number-1])
			
## Gets all of the parts in descending order in the form [[number, count]]. For example, 1+2(5)
## would return [(5, 2), (1, 1)]. Generally, it is best practice to use for_each_part() instead.
func get_parts() -> Array[Array]:
	var parts: Array[Array] = []
	for number: int in range(len(self.parts), 0, -1):
		if self.parts[number-1] != 0:
			parts.append([number, self.parts[number-1]])
	return parts
	
## As above, but with an ascending order
func for_each_part_ascending(action: Callable) -> void:
	var number: int = 0
	for occurrences: int in parts:
		number += 1
		if occurrences != 0:
			action.call(number, occurrences)

# Constants used in drawing Young diagrams
const horizontal_padding: int = 32
const vertical_padding: int = 16
const max_square_size: int = 32
const border_width: int = 2
var y: int = 0 # used internally in draw_contents

# Draw Young diagrams
# - Calculate how much vertical and horizontal space we need
# - Given how much space we've got, work out how big the cubes can be
# - Using the size of the cubes, get the position of each cube
# - Go over these cubes and draw them
func draw_contents_diagrams() -> void:
	# Work out how much space we have to work with
	var available_space: Vector2 = size - Vector2(horizontal_padding * 2, vertical_padding * 2)
	
	# Work out the length and width of the squares if we want to fill this space
	var max_square_width: int = available_space.x / get_largest_part()
	var max_square_height: int = available_space.y / count_parts()
	
	# We want to keep the squares square, but this can be changed to allow for rectangles
	var square_size: int = min(max_square_width, max_square_height)
	
	# Let's stop it from getting silly by restricting the maximum size (only affects small numbers)
	square_size = min(square_size, max_square_size)

	# Now we can go through each part and draw all of the square
	y = vertical_padding
	var x: int = horizontal_padding
	self.for_each_part(func draw_part(num: int, count: int) -> void:
		# Add the same row as many times as we need to
		for c: int in range(count):
			# Within this row, add squares until reaching the value of the number
			for i: int in range(num):
				# Draw black outline, then put a white square on the top
				#draw_rect(Rect2(Vector2(x, y), Vector2(square_size, square_size)), Color.BLACK)
				#draw_rect(Rect2(
					#Vector2(x+border_width, y+border_width), # position
					#Vector2(square_size-border_width*2, square_size-border_width*2) # size
				#), Color.WHITE)
				# Draw four lines around the perimeter
				draw_line(Vector2(x, y), Vector2(x+square_size, y), Color.BLACK, border_width)
				draw_line(Vector2(x+square_size, y), Vector2(x+square_size, y+square_size), Color.BLACK, border_width)
				draw_line(Vector2(x+square_size, y+square_size), Vector2(x, y+square_size), Color.BLACK, border_width)
				draw_line(Vector2(x, y+square_size), Vector2(x, y), Color.BLACK, border_width)
				x += square_size
			self.y += square_size
			x = horizontal_padding
	)


# Generates all partitions of a number n
# Output: Array of partitions, where each partition is an array of integers in descending order
static func generate_partitions(n: int, max_part: int = n) -> Array[Array]:
	# Base case: No partitions of 0
	if n == 0:
		return [[]]

	var partitions: Array[Array] = []
	# Generate the partitions recursively
	for largest_part: int in range(min(n, max_part), 0, -1):
		# Generate the partitions of n - largest_part
		var sub_partitions: Array[Array] = generate_partitions(n - largest_part, largest_part)
		# Add the largest part to each partition
		for sub_partition: Array[int] in sub_partitions:
			partitions.append([largest_part] + sub_partition)

	# Return the partitions
	return partitions