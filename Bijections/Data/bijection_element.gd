## An element in a bijection
##
## @param text The text to show onscreen
## @param id   The ID, used to check if the answer is correct. There must be exactly two elements
##		with each ID (one on each side of the bijection).
## @param match Which element it is matched to

class_name BijectionElement

var text: String
var id: int
var match: BijectionElement = null
var pos: Vector2 = Vector2(0, 0)
var size: Vector2 = Vector2(300, 100)
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
