extends CatalanProblem
class_name CatalanProblemBase

var size_0: Array[BijectionElement]
var size_1: Array[BijectionElement]
var size_2: Array[BijectionElement]
var size_3: Array[BijectionElement]
var size_4: Array[BijectionElement]

func _init(title: String, description: String, id: int, 
		size_0: Array[BijectionElement], size_1: Array[BijectionElement], size_2: Array[BijectionElement], 
		size_3: Array[BijectionElement], size_4: Array[BijectionElement],
		bijections: Dictionary = {}, representation: String = "", definitions: Array[BijectionDefinition] = []) -> void:
	super(
		title,
		description,
		id,
		bijections,
		representation,
		definitions
	)
	self.size_0 = size_0
	self.size_1 = size_1
	self.size_2 = size_2
	self.size_3 = size_3
	self.size_4 = size_4

# Used to be stored as a dict, but this messed up the typing (Godot didn't believe me that the array
# contained BijectionElements)
# NOTE: The keys present in this will control which problem sizes are displayed to the user. It is 
# assumed that this does not vary between problems.
func get_sizes_dict() -> Dictionary:
	return {
		0: self.size_0,
		1: self.size_1,
		2: self.size_2,
		3: self.size_3,
		4: self.size_4
	}