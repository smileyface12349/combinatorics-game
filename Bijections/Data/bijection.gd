extends Node
class_name Bijection

var from: Array[BijectionElement]
var to: Array[BijectionElement]
var problem_size: int
var quiz: bool = false

func _init(problem_size: int, from: Array[BijectionElement], to: Array[BijectionElement], quiz: bool = false) -> void:
	self.from = from
	self.to = to
	self.problem_size = problem_size
	self.quiz = quiz
	
func all_elements() -> Array[BijectionElement]:
	return self.from + self.to
	
func get_elements_on_side(left: bool) -> Array[BijectionElement]:
	if left:
		return self.from
	else:
		return self.to
		
## Draw the elements. This:
##  - Computes the position for each element
##  - Populates element.pos with the position
##  - Calls draw_element for each element
#func draw_elements(draw_element: Callable, spacing: int = 16, 
		#top_spacing: int = 64, width_half: int = 700,
		#mouse_position: Vector2 = Vector2(0, 0)) -> void:
	## Draw LHS
	#var y: int = top_spacing
	#for element: BijectionElement in self.from:
		#element.pos = Vector2((width_half - element.size.x) / 2 - element.size.x/2, y)
		#draw_element.call(element, element.is_inside(mouse_position))
		#y += element.size.y + spacing
		#
	## Draw RHS
	#y = top_spacing
	#for element: BijectionElement in self.to:
		#element.pos = Vector2((width_half - element.size.x) / 2 + width_half - element.size.x/2, y)
		#draw_element.call(element, element.is_inside(mouse_position))
		#y += element.size.y + spacing
		
## Checks if the current matching is correct
func check() -> bool:
	for element: BijectionElement in self.from:
		if element.match == null || element.match.id != element.id:
			return false
	return true

## Shuffles the elements (this is really important to do before displaying!)
func shuffle_order() -> void:
	self.from.shuffle()
	self.to.shuffle()
