extends BijectionElement
class_name DyckPathElement

var steps: Array[int] # 1 = up step, -1 = down step

func _init(steps: Array[int], id: int) -> void:
	self.steps = steps
	
	# Obtain a string representation to use when diagrams are disabled
	var text: String = ""
	for step: int in steps:
		if step == 1:
			text += "U"
		elif step == -1:
			text += "D"
		else:
			text += "_"
		
	# Check that it is a valid Dyck path
	var height: int = 0
	for step: int in steps:
		height += step
		assert(height >= 0)
	assert(height == 0)
	
	# Initialise super
	super(text, id)

# No text representation for this
func draw_contents_text() -> void:
	draw_contents_diagrams()

# Get the height of the highest peak
func get_max_height() -> int:
	var height: int = 0
	var max_height: int = 0
	for step: int in self.steps:
		height += step
		if height > max_height:
			max_height = height
	return max_height
	
# Get the number of steps
func get_width() -> int:
	return len(self.steps)

# Constants used in drawing Young diagrams
const horizontal_padding: int = 32
const vertical_padding: int = 32
const max_square_size: int = 48
const line_width: int = 2
const dot_radius: int = 5

# Draw a visual representation of the Dyck path
# - Figure out the height and width
# - Determine the max size we can do for each part of the walk
# - Draw the lines and dots to make the path
func draw_contents_diagrams() -> void:
	# Work out how much space we have to work with
	var available_space: Vector2 = size - Vector2(horizontal_padding * 2, vertical_padding * 2)
	
	# Work out the length and width of the squares if we want to fill this space
	var max_square_width: int = available_space.x / get_width()
	var max_square_height: int = available_space.y / get_max_height()
	
	# We want to keep the squares square, but this can be changed to allow for rectangles
	var square_size: int = min(max_square_width, max_square_height)
	
	# Let's stop it from getting silly by restricting the maximum size (only affects small numbers)
	square_size = min(square_size, max_square_size)
	
	# Draw a dot to begin with
	var y: int = size.y - vertical_padding
	var x: int = horizontal_padding
	draw_circle(Vector2(x, y), dot_radius, Color.BLACK)

	# Now we can go through each step and draw the rest of it
	
	for step: int in steps:
		# work out the next position
		var new_x: int = x + square_size
		var new_y: int = y + square_size * step * -1
		
		# draw a line between these points
		draw_line(Vector2(x, y), Vector2(new_x, new_y), Color.BLACK, line_width)
		
		# update the co-ordinates
		x = new_x
		y = new_y
		
		# draw a dot at the end of the line
		draw_circle(Vector2(x, y), dot_radius, Color.BLACK)
		
