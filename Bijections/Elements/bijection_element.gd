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
var match: BijectionElement = null
var hover: bool = false
var side: bool # done when adding to scene, not during setup
# var size: Vector2 = Vector2(300, 100)

const font_size: float = 48
var font: Font = load("res://fonts/source-code-pro/source-code-pro-2.010R-ro-1.030R-it/TTF/SourceCodePro-Black.ttf")

func _init(text: String, id: int) -> void:
	self.text = text
	self.id = id
	self.connect("mouse_entered", func () -> void: hover = true; queue_redraw())
	self.connect("mouse_exited", func () -> void: hover = false; queue_redraw())
	
	
func is_inside(pos: Vector2) -> bool:
	return pos.x >= position.x && pos.y >= position.y \
	 	&& pos.x <= position.x + size.x && pos.y <= position.y + size.y
		
## Gets the position to draw the line from (the left/right middle)
func get_line_pos() -> Vector2:
	if side:
		return Vector2(position.x + size.x, position.y + size.y/2)
	else:
		return Vector2(position.x, position.y + size.y/2)
		
## Check against user input
func check(test: String) -> bool:
	return self.text == test
	
## Draw contents of bijection element. By default, this is a string.
## All elements have a string representation. Some subclasses have pictoral representations.
func draw_contents() -> void:
	draw_string(font, Vector2(16, size.y * 0.6), self.text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, Color(0, 0, 0))

func _ready() -> void:
	# Add dot as a separate element, so it can draw in front of the lines
	var dot: BijectionElementDot = BijectionElementDot.new()
	dot.position = Vector2(size.x if side else 0, size.y/2)
	dot.z_index = 1
	add_child(dot)

func _draw() -> void:
	# Draw background for button
	draw_rect(Rect2(Vector2(0, 0), size), Color.ALICE_BLUE if hover else Color.WHITE, true)
	# Draw outline for button
	draw_rect(Rect2(Vector2(0, 0), size), Color.BLUE if hover else Color.BLACK, false)
	# Draw contents (text or a diagram)
	draw_contents()
	
