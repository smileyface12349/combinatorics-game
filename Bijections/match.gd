extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var width: int = 10
var color: Color = Color.GREEN

var mouse_position_drawn: Vector2 = Vector2(0, 0)

@export var font: Font

class BijectionElement:
	var text: String
	var match: BijectionElement = null
	var pos: Vector2 = Vector2(0, 0)
	var size: Vector2 = Vector2(64, 32)
	var left: bool
	
	func _init(text: String, left: bool) -> void:
		self.text = text
		self.left = left
		
	func is_inside(pos: Vector2) -> bool:
		return pos.x >= self.pos.x && pos.y >= self.pos.y \
		 	&& pos.x <= self.pos.x + self.size.x && pos.y <= self.pos.y + self.size.y

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
		
var bijection = Bijection.new(
	# Left elements
	[
		BijectionElement.new("{}", true), 
		BijectionElement.new("{1}", true),
		BijectionElement.new("{2}", true),
		BijectionElement.new("{1, 2}", true),
	],
	# Right elements 
	[
		BijectionElement.new("00", false),
		BijectionElement.new("10", false),
		BijectionElement.new("01", false),
		BijectionElement.new("11", false)
	]
)

var active_element: BijectionElement = null

func _input(event) -> void:
	# Left mouse button pressed
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		# If there aren't any selected yet...
		if active_element == null:
			# See if we've clicked on any elements
			for element in bijection.all_elements():
				if element.is_inside(event.position - get_global_position()):
					# If so, draw a line starting at this element
					active_element = element
					break
		# If we've already selected an element...
		else:
			# See if we've clicked on any elements on the other side
			for element in bijection.get_elements(!active_element.left):
				if element.is_inside(event.position - get_global_position()):
					# If so, match these up. Only store matchings from left to right
					if element.left:
						element.match = active_element
					else:
						active_element.match = element
					print("Matched " + element.text + " to " + active_element.text)
					active_element = null
					break
			# If we missed, just clear the active element anyway
			active_element = null
		# Whatever happened, it's time for a redraw
		queue_redraw()


func _process(_delta):
	var mouse_position = get_viewport().get_mouse_position() - get_global_position()
	if mouse_position != mouse_position_drawn:
		mouse_position_drawn = mouse_position
		queue_redraw()

func _draw():

	# Draw LHS
	var pos := Vector2(32, 32)
	for element: BijectionElement in bijection.from:
		draw_string(font, pos, element.text, HORIZONTAL_ALIGNMENT_CENTER, -1, 24, Color(0, 0, 0))
		element.pos = pos
		pos += Vector2(0, 64)
		
	# Draw RHS
	pos = Vector2(1000, 32)
	for element: BijectionElement in bijection.to:
		draw_string(font, pos, element.text, HORIZONTAL_ALIGNMENT_CENTER, -1, 24, Color(0, 0, 0))
		element.pos = pos
		pos += Vector2(0, 64)
		
	# Draw matchings that have already been done
	for element: BijectionElement in bijection.from:
		if element.match != null:
			draw_line(element.pos, element.match.pos, Color.RED, width)
			
	# Draw active matching (if applicable)
	if active_element != null:
		draw_line(active_element.pos, mouse_position_drawn, Color.GREEN, width)
		
