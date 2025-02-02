extends Control
class_name MatchElements

var bijection: Bijection = LoadingBijection.new()
	
func set_bijection(new_bijection: Bijection) -> void:
	bijection = new_bijection
	bijection.shuffle_order()
	queue_redraw()

const line_width: int = 8

var done: bool = false
var show_diagrams: bool = false

var mouse_position_drawn: Vector2 = Vector2(0, 0)

@export var font: Font
@export var problemSizeIndicator: RichTextLabel

var active_element: BijectionElement = null
var active_element_side: bool = true

var active_line: Line2D

func _input(event: InputEvent) -> void:
	# Left mouse button pressed
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		# If there aren't any selected yet...
		if active_element == null:
			# See if we've clicked on any elements
			for side: bool in [true, false]:
				for element: BijectionElement in bijection.get_elements_on_side(side):
					if element.is_inside(get_local_mouse_position()):
						# If so, draw a line starting at this element
						active_element = element
						active_element_side = side
						active_line = Line2D.new()
						active_line.default_color = Color.BLUE
						active_line.points = [active_element.get_line_pos(), get_local_mouse_position()]
						add_child(active_line)
						# Check if we need to remove any old lines
						for e: BijectionElement in bijection.from:
							if e == active_element || e.match == active_element:
								e.match = null
						# If they've won already, invalidate this as it's been modified
						done = false
						break
		# If we've already selected an element...
		else:
			# See if we've clicked on any elements on the other side
			for element: BijectionElement in bijection.get_elements_on_side(!active_element_side):
				if element.is_inside(get_local_mouse_position()):
					# If so, match these up. Only store matchings from left to right
					if !active_element_side:
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
			remove_child(active_line)
		# Whatever happened, it's time for a redraw
		queue_redraw()

func check_bijection() -> void:
	if bijection.check():
		done = true
		queue_redraw()
		await get_tree().create_timer(1.0).timeout
		# TODO: Move camera?

func _process(_delta: float) -> void:
	var mouse_position: Vector2 = get_local_mouse_position()
	if mouse_position != mouse_position_drawn:
		# Move active line
		if active_line:
			active_line.set_point_position(1, mouse_position)
		
		#mouse_position_drawn = mouse_position
		#queue_redraw()
		
const top_spacing: int = 128
const width_half: int = 700
const spacing: int = 32
const default_element_size: Vector2 = Vector2(300, 100)
const default_diagram_size: Vector2 = Vector2(300, 200)

func _ready() -> void:
	# Add nodes for each BijectionElement.
	# Lines are drawn using _draw, and do not get elements made.
	
	# Draw LHS
	var y: int = top_spacing
	for element: BijectionElement in bijection.from:
		element.size = default_element_size
		element.position = Vector2((width_half - element.size.x) / 2 - element.size.x/2, y)
		element.side = true
		self.add_child(element)
		y += element.size.y + spacing
		
	# Draw RHS
	y = top_spacing
	for element: BijectionElement in bijection.to:
		element.size = default_element_size
		element.position = Vector2((width_half - element.size.x) / 2 + width_half - element.size.x/2, y)
		element.side = false
		self.add_child(element)
		y += element.size.y + spacing
		
## Changes the size of the elements.
## Does not ask them to redraw themselves. Please make sure this is done as the contents can often
## be rendered differently depending on the size.
func resize_elements(element_size: Vector2 = default_element_size) -> void:
	# Draw LHS
	var y: int = top_spacing
	for element: BijectionElement in bijection.from:
		element.size = element_size
		element.position = Vector2((width_half - element.size.x) / 2 - element.size.x/2, y)
		y += element.size.y + spacing
		
	# Draw RHS
	y = top_spacing
	for element: BijectionElement in bijection.to:
		element.size = element_size
		element.position = Vector2((width_half - element.size.x) / 2 + width_half - element.size.x/2, y)
		y += element.size.y + spacing
		
	# Redraw the red lines
	queue_redraw()
		
func set_show_diagrams(show_diagrams: bool) -> void:
	# Store the new value
	self.show_diagrams = show_diagrams
	
	# Change size and positions
	if show_diagrams:
		self.resize_elements(default_diagram_size)
	else:
		self.resize_elements()
	
	# Ask each element to redraw itself
	for element: BijectionElement in bijection.all_elements():
		element.set_show_diagrams(show_diagrams)

func _draw() -> void:
		
	# TODO: Make a node for each BijectionElement. This is better than trying to draw everything here!
		
	# Define function to draw an element after its position has been assigned
	#var draw_element: Callable = func (element: BijectionElement, hover: bool = false) -> void:
		## Draw background for button
		#draw_rect(Rect2(element.pos, element.size), Color.ALICE_BLUE if hover else Color.WHITE, true)
		## Draw outline for button
		#draw_rect(Rect2(element.pos, element.size), Color.BLUE if hover else Color.BLACK, false)
		## Position of text is the bottom-left corner
		#element.draw(draw_string)
		## Draw dot later so it's in front of the lines
		
	# Draw the elements
	#bijection.draw_elements(
		#draw_element,
		#32, # vertical spacing between them
		#128, # vertical spacing before the first element
		#700, # width of each half (will be centered automatically)
		#mouse_position_drawn
	#)
	
	# Draw matchings that have already been done
	for element: BijectionElement in bijection.from:
		if element.match != null:
			draw_line(element.get_line_pos(), element.match.get_line_pos(), Color.GREEN if done else Color.RED, line_width)
			
	# Draw active matching (if applicable)
	#if active_element != null:
		#draw_line(active_element.get_line_pos(active_element_side), mouse_position_drawn, Color.BLUE, line_width)
		#
	# Draw dots (so they are in front of the lines)
	#for side: bool in [true, false]:
		#for element: BijectionElement in bijection.get_elements_on_side(side):
			#draw_circle(element.position + Vector2(element.size.x if side else 0, element.size.y/2), circle_radius, Color.BLACK)
