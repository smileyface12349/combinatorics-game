extends Node
class_name CatalanProblem

var sizes: Dictionary # {problem_size: catalan_problem_n}
var description: String
var title: String
var id: int
var proofs: Dictionary # {id: proof}
var definitions: Array[BijectionDefinition]

func _init(title: String, description: String, id: int, sizes: Dictionary, proofs: Dictionary = {}, definitions: Array[BijectionDefinition] = []) -> void:
	self.title = title
	self.description = description
	self.id = id
	self.sizes = sizes
	self.proofs = proofs
	self.definitions = definitions
