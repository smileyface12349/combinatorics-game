extends Control

var problem_size: int = 1
var bijection: Bijection

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialise the bijection (temp code until levels are created properly)
	initialise_bijection(problem_size)
	# Shuffling order currently done inside this function	
	

func initialise_bijection(problem_size: int) -> void:
	problemSizeIndicator.text = "n = " + str(problem_size-1)
	
	if problem_size == 1:
		bijection = Bijection.new(
			# Left elements
			[
				BijectionElement.new("{}", true, 1), 
			],
			# Right elements 
			[
				BijectionElement.new("", false, 1),
			]
		)

	elif problem_size == 2:
		bijection = Bijection.new(
			# Left elements
			[
				BijectionElement.new("{}", true, 1), 
				BijectionElement.new("{1}", true, 2),
			],
			# Right elements 
			[
				BijectionElement.new("0", false, 1),
				BijectionElement.new("1", false, 2),
			]
		)
	
	elif problem_size == 3:
		bijection = Bijection.new(
			# Left elements
			[
				BijectionElement.new("{}", true, 1), 
				BijectionElement.new("{1}", true, 2),
				BijectionElement.new("{2}", true, 3),
				BijectionElement.new("{1, 2}", true, 4),
			],
			# Right elements 
			[
				BijectionElement.new("00", false, 1),
				BijectionElement.new("10", false, 2),
				BijectionElement.new("01", false, 3),
				BijectionElement.new("11", false, 4),
			]
		)
		
	else:	
		bijection = Bijection.new(
			# Left elements
			[
				BijectionElement.new("{}", true, 1), 
				BijectionElement.new("{1}", true, 2),
				BijectionElement.new("{2}", true, 3),
				BijectionElement.new("{1, 2}", true, 4),
				BijectionElement.new("{3}", true, 5), 
				BijectionElement.new("{1, 3}", true, 6),
				BijectionElement.new("{2, 3}", true, 7),
				BijectionElement.new("{1, 2, 3}", true, 8),
			],
			# Right elements 
			[
				BijectionElement.new("000", false, 1),
				BijectionElement.new("100", false, 2),
				BijectionElement.new("010", false, 3),
				BijectionElement.new("110", false, 4),
				BijectionElement.new("001", false, 5),
				BijectionElement.new("101", false, 6),
				BijectionElement.new("011", false, 7),
				BijectionElement.new("111", false, 8)
			]
		)
		
	# Shuffle the order for the bijection
	bijection.from.shuffle()
	bijection.to.shuffle()

var line_width: int = 8
var circle_radius: float = 6
var done: bool = false

var mouse_position_drawn: Vector2 = Vector2(0, 0)

@export var font: Font
@export var problemSizeIndicator: RichTextLabel

## An element in a bijection
##
## @param text The text to show onscreen
## @param id   The ID, used to check if the answer is correct. There must be exactly two elements
##		with each ID (one on each side of the bijection).
## @param match Which element it is matched to
class BijectionElement:
	var text: String
	var id: int
	var match: BijectionElement = null
	var pos: Vector2 = Vector2(0, 0)
	var size: Vector2 = Vector2(128, 64)
	var left: bool
	
	func _init(text: String, left: bool, id: int) -> void:
		self.text = text
		self.left = left
		self.id = id
		
	func is_inside(pos: Vector2) -> bool:
		return pos.x >= self.pos.x && pos.y >= self.pos.y \
		 	&& pos.x <= self.pos.x + self.size.x && pos.y <= self.pos.y + self.size.y
			
	## Gets the position to draw the line from (the left/right middle)
	func get_line_pos() -> Vector2:
		if self.left:
			return Vector2(self.pos.x + self.size.x, self.pos.y + self.size.y/2)
		else:
			return Vector2(self.pos.x, self.pos.y + self.size.y/2)

class Bijection:
	var from: Array[BijectionElement]
	var to: Array[BijectionElement]
	
	func _init(from: Array[BijectionElement], to: Array[BijectionElement]) -> void:
		self.from = from
		self.to = to
		
	func all_elements() -> Array[BijectionElement]:
		return self.from + self.to
		
	func get_elements(left: bool) -> Array[BijectionElement]:
		if left:
			return self.from
		else:
			return self.to
			
	## Draw the elements. This:
	##  - Computes the position for each element
	##  - Populates element.pos with the position
	##  - Calls draw_element for each element
	func draw_elements(draw_element: Callable, spacing: int = 16, 
			start_left: Vector2 = Vector2(32, 32), start_right: Vector2 = Vector2(1000, 32),
			mouse_position: Vector2 = Vector2(0, 0)) -> void:
		# Draw LHS
		var pos: Vector2 = start_left
		for element: BijectionElement in self.from:
			element.pos = pos
			draw_element.call(element, element.is_inside(mouse_position))
			pos += Vector2(0, element.size.y + spacing)
			
		# Draw RHS
		pos = start_right
		for element: BijectionElement in self.to:
			element.pos = pos
			draw_element.call(element, element.is_inside(mouse_position))
			pos += Vector2(0, element.size.y + spacing)
			
	## Checks if the current matching is correct
	func check() -> bool:
		for element: BijectionElement in self.from:
			if element.match == null || element.match.id != element.id:
				return false
		return true
		


var active_element: BijectionElement = null

func _input(event: InputEvent) -> void:
	# Left mouse button pressed
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		# If there aren't any selected yet...
		if active_element == null:
			# See if we've clicked on any elements
			for element: BijectionElement in bijection.all_elements():
				if element.is_inside(event.position - get_global_position()):
					# If so, draw a line starting at this element
					active_element = element
					# Check if we need to remove any old lines
					for e: BijectionElement in bijection.from:
						if e == active_element || e.match == active_element:
							e.match = null
					break
		# If we've already selected an element...
		else:
			# See if we've clicked on any elements on the other side
			for element: BijectionElement in bijection.get_elements(!active_element.left):
				if element.is_inside(event.position - get_global_position()):
					# If so, match these up. Only store matchings from left to right
					if element.left:
						element.match = active_element
					else:
						# Check if we need to remove an old matching
						for e: BijectionElement in bijection.from:
							if e.match == element:
								e.match = null
						# Add the new matching
						active_element.match = element
					active_element = null
					check_bijection()
					break
			# If we missed, just clear the active element anyway
			active_element = null
		# Whatever happened, it's time for a redraw
		queue_redraw()

func check_bijection() -> void:
	if bijection.check():
		done = true
		await get_tree().create_timer(1.0).timeout
		problem_size += 1
		initialise_bijection(problem_size)
		done = false
		queue_redraw()

func _process(_delta: float) -> void:
	var mouse_position: Vector2 = get_viewport().get_mouse_position() - get_global_position()
	if mouse_position != mouse_position_drawn:
		mouse_position_drawn = mouse_position
		queue_redraw()

func _draw() -> void:
		
	# Define function to draw an element after its position has been assigned
	var draw_element: Callable = func (element: BijectionElement, hover: bool = false) -> void:
		# Draw background for button
		draw_rect(Rect2(element.pos, element.size), Color.ALICE_BLUE if hover else Color.WHITE, true)
		# Draw outline for button
		draw_rect(Rect2(element.pos, element.size), Color.BLUE if hover else Color.BLACK, false)
		# Position of text is the bottom-left corner
		draw_string(font, element.pos + Vector2(16, element.size.y/2), element.text, HORIZONTAL_ALIGNMENT_CENTER, -1, 24, Color(0, 0, 0))
		# Draw dot later so it's in front of the lines
		

	# Draw the elements
	bijection.draw_elements(
		draw_element,
		16,
		Vector2(32, 32),
		Vector2(948, 32),
		mouse_position_drawn
	)
	
	# Draw matchings that have already been done
	for element: BijectionElement in bijection.from:
		if element.match != null:
			draw_line(element.get_line_pos(), element.match.get_line_pos(), Color.GREEN if done else Color.RED, line_width)
			
	# Draw active matching (if applicable)
	if active_element != null:
		draw_line(active_element.get_line_pos(), mouse_position_drawn, Color.BLUE, line_width)
		
	# Draw dots (so they are in front of the lines)
	for element: BijectionElement in bijection.all_elements():
		draw_circle(element.pos + Vector2(element.size.x if element.left else 0, element.size.y/2), circle_radius, Color.BLACK)
