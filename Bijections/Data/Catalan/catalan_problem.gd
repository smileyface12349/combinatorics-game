extends Node
class_name CatalanProblem

var size_0: Array[BijectionElement]
var size_1: Array[BijectionElement]
var size_2: Array[BijectionElement]
var size_3: Array[BijectionElement]
var size_4: Array[BijectionElement]
var description: String
var title: String
var id: int
var proofs: Dictionary # {id: proof}
var definitions: Array[BijectionDefinition]

func _init(title: String, description: String, id: int, 
		size_0: Array[BijectionElement], size_1: Array[BijectionElement], size_2: Array[BijectionElement], 
		size_3: Array[BijectionElement], size_4: Array[BijectionElement],
		proofs: Dictionary = {}, definitions: Array[BijectionDefinition] = []) -> void:
	self.title = title
	self.description = description
	self.id = id
	self.proofs = proofs
	self.definitions = definitions
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
