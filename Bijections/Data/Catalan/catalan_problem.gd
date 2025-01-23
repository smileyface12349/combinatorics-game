extends Node
class_name CatalanProblem

var sizes: Dictionary # {problem_size: catalan_problem_n}
var description: String
var title: String
var id: int
var proofs: Dictionary # {id: proof}

func _init(title: String, description: String, sizes: Dictionary, id: int, proofs: Dictionary = {}) -> void:
	self.sizes = sizes
	self.title = title
	self.description = description
	self.id = id
	self.proofs = proofs
