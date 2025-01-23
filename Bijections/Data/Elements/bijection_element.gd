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

extends Node
class_name BijectionElement

var text: String
var id: int
var match: BijectionElement = null
var pos: Vector2 = Vector2(0, 0)
var size: Vector2 = Vector2(300, 100)

const font_size: float = 48
var font: Font = load("res://fonts/source-code-pro/source-code-pro-2.010R-ro-1.030R-it/TTF/SourceCodePro-Black.ttf")

func _init(text: String, id: int) -> void:
	self.text = text
	self.id = id
	
	
func is_inside(pos: Vector2) -> bool:
	return pos.x >= self.pos.x && pos.y >= self.pos.y \
	 	&& pos.x <= self.pos.x + self.size.x && pos.y <= self.pos.y + self.size.y
		
## Gets the position to draw the line from (the left/right middle)
func get_line_pos(is_on_left: bool) -> Vector2:
	if is_on_left:
		return Vector2(self.pos.x + self.size.x, self.pos.y + self.size.y/2)
	else:
		return Vector2(self.pos.x, self.pos.y + self.size.y/2)
		
## Check against user input
func check(test: String) -> bool:
	return self.text == test
	
## Draw contents of bijection element. By default, this is a string.
## All elements have a string representation. Some subclasses have pictoral representations.
func draw(draw_string: Callable) -> void:
	draw_string.call(font, pos + Vector2(16, size.y * 0.6), self.text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, Color(0, 0, 0))
