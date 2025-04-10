## An element in a bijection.
##
## Elements know their ID (to simplify some management of objects), but they do not know which side
## of the bijection they are on. You may need to retain this from where the element is stored and
## pass it into any functions that require it.
##
## @param text The text to show onscreen
## @param id   The ID, used to check if the answer is correct. There must be exactly two elements
##		with each ID (one on each side of the bijection).
## @param match Which element it is matched to

extends Control
class_name BijectionElement

var text: String
var id: int
var alternate: Array[int] = []
var match: BijectionElement = null
var hover: bool = false
var side: bool # done when adding to scene, not during setup
var show_diagrams: bool = false

var dot: BijectionElementDot

const font_size: float = 48
var font: Font = load("res://fonts/source-code-pro/source-code-pro-2.010R-ro-1.030R-it/TTF/SourceCodePro-Black.ttf")

func _init(text: String, id: int, alternate: Array[int] = []) -> void:
	self.text = text
	self.id = id
	self.alternate = alternate
	self.connect("mouse_entered", func () -> void: hover = true; queue_redraw())
	self.connect("mouse_exited", func () -> void: hover = false; queue_redraw())
	
# Please call this function after changing the size of the node
# It is safe to call even if the size hasn't actually changed
func on_resize() -> void:
	dot.position = Vector2(size.x if side else 0, size.y/2)
	
func set_show_diagrams(show_diagrams: bool) -> void:
	self.show_diagrams = show_diagrams
	queue_redraw()
	on_resize()
	
func is_inside(pos: Vector2) -> bool:
	var is_inside_box: bool = pos.x >= position.x && pos.y >= position.y \
	 	&& pos.x <= position.x + size.x && pos.y <= position.y + size.y
	var is_inside_dot: bool = pos.distance_to(position + dot.position) <= BijectionElementDot.hitbox_radius
	return is_inside_box or is_inside_dot
		
## Gets the position to draw the line from (the left/right middle)
func get_line_pos() -> Vector2:
	if side:
		return Vector2(position.x + size.x, position.y + size.y/2)
	else:
		return Vector2(position.x, position.y + size.y/2)
		
## Check against user input
func check(test: String) -> bool:
	return self.text == test
	
## Draw contents of bijection element, showing the string representation. This may be overridden,
## but probably doesn't need to be as all classes should have a string representation.
func draw_contents_text() -> void:
	if self.text == "":
		# Special text for empty cases
		draw_empty()
	else:
		draw_string(font, Vector2(16, size.y * 0.6), self.text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, Color(0, 0, 0))

## All elements have a string representation. Some subclasses have pictoral representations.
func draw_contents_diagrams() -> void:
	draw_contents_text() # Overridden in subclasses

# Draw a special note to say that something is empty, instead of just drawing a blank box
func draw_empty() -> void:
	draw_string(font, Vector2(16, size.y * 0.6), "(empty)", HORIZONTAL_ALIGNMENT_CENTER, -1, font_size / 2, Color(0, 0, 0, 0.5))

# Get the best representation for code input
func get_code_representation() -> Variant:
	return self.text

func _ready() -> void:
	# Add dot as a separate element, so it can draw in front of the lines
	dot = BijectionElementDot.new()
	dot.position = Vector2(size.x if side else 0, size.y/2)
	dot.z_index = 1
	add_child(dot)

func _draw() -> void:
	# Draw background for button
	draw_rect(Rect2(Vector2(0, 0), size), Color.ALICE_BLUE if hover else Color.WHITE, true)
	# Draw outline for button
	draw_rect(Rect2(Vector2(0, 0), size), Color.BLUE if hover else Color.BLACK, false)
	# Draw contents (text or a diagram)
	if show_diagrams:
		draw_contents_diagrams()
	else:
		draw_contents_text()
	
