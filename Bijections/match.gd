extends Control
class_name MatchElements

var bijection: Bijection = LoadingBijection.new()
	
func set_bijection(new_bijection: Bijection) -> void:
	print_debug("Bijection set!")
	bijection = new_bijection
	bijection.shuffle_order()
	queue_redraw()

const line_width: int = 8
const circle_radius: float = 10
const font_size: float = 48

var done: bool = false

var mouse_position_drawn: Vector2 = Vector2(0, 0)

@export var font: Font
@export var problemSizeIndicator: RichTextLabel


var active_element: BijectionElement = null

func _input(event: InputEvent) -> void:
	# Left mouse button pressed
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		# If there aren't any selected yet...
		if active_element == null:
			# See if we've clicked on any elements
			for element: BijectionElement in bijection.all_elements():
				if element.is_inside(get_local_mouse_position()):
					# If so, draw a line starting at this element
					active_element = element
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
			for element: BijectionElement in bijection.get_elements(!active_element.left):
				if element.is_inside(get_local_mouse_position()):
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
		queue_redraw()
		await get_tree().create_timer(1.0).timeout
		# TODO: Move camera?

func _process(_delta: float) -> void:
	var mouse_position: Vector2 = get_local_mouse_position()
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
		draw_string(font, element.pos + Vector2(16, element.size.y * 0.6), element.text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, Color(0, 0, 0))
		# Draw dot later so it's in front of the lines
		
	# Draw the elements
	bijection.draw_elements(
		draw_element,
		32, # vertical spacing between them
		128, # vertical spacing before the first element
		700, # width of each half (will be centered automatically)
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
