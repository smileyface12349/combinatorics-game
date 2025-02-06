class_name BijectionLevel

var bijections: Dictionary # {problem_size: bijection}
var left_text: String
var right_text: String
var left_title: String
var right_title: String
var definitions: Array[BijectionDefinition]
var hint: String
var proof: BijectionProof

func _init(left_title: String, right_title: String, left_description: String, right_description: String, bijections: Dictionary, definitions: Array[BijectionDefinition] = [], hint: String = "", proof: BijectionProof = BijectionProof.new()) -> void:
	self.left_title = left_title
	self.left_text = left_description
	self.right_title = right_title
	self.right_text = right_description
	self.bijections = bijections
	self.definitions = definitions
	self.hint = hint
	self.proof = proof

static func from_catalan_problems(problem1: CatalanProblem, problem2: CatalanProblem) -> BijectionLevel:
	var bijections: Dictionary = {}
	for size: int in problem1.get_sizes_dict():
		var from: Array[BijectionElement] = problem1.get_sizes_dict()[size] as Array[BijectionElement]
		var to: Array[BijectionElement] = problem2.get_sizes_dict()[size] as Array[BijectionElement]
		bijections[size] = Bijection.new(size, from, to)
	# TODO: Add hints and proofs
	return BijectionLevel.new(problem1.title, problem2.title, problem1.description, problem2.description, bijections, problem1.definitions + problem2.definitions)
