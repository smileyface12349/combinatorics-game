extends BijectionElement
class_name IntegerPartitionElement

var parts: Array[int]

## parts: [number of 1s, number of 2s, number of 3s, ...]
func _init(parts: Array[int], id: int) -> void:
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
	self.parts = parts

# TODO: Draw Young diagrams
# - Calculate how much vertical and horizontal space we need
# - Given how much space we've got, work out how big the cubes can be
# - Using the size of the cubes, get the position of each cube
# - Go over these cubes and draw them

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
	
## Iterates through every part with a non-zero number of occurrences in descending order, and calls
## the function. For example, 1+2(5) would call with (5, 2) then call with (1, 1)
func for_each_part(action: Callable) -> void:
	for number: int in range(len(parts), 0, -1):
		if self.parts[number-1] != 0:
			action.call(number, self.parts[number-1])
	
## As above, but with an ascending order
func for_each_part_ascending(action: Callable) -> void:
	var number: int = 0
	for occurrences: int in parts:
		number += 1
		if occurrences != 0:
			action.call(number, occurrences)

const horizontal_padding: int = 32
const vertical_padding: int = 16
const max_square_size: int = 24
var y: int = 0 # used internally in draw_contents

func draw_contents() -> void:
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
				draw_rect(Rect2(Vector2(x, y), Vector2(square_size, square_size)), Color.BLACK)
				draw_rect(Rect2(Vector2(x+1, y+1), Vector2(square_size-2, square_size-2)), Color.WHITE)
				x += square_size
			self.y += square_size
			x = horizontal_padding
	)
