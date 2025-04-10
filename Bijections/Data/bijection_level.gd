class_name BijectionLevel

var id: Variant
var bijections: Dictionary # {problem_size: bijection}
var left_generator: Callable
var right_generator: Callable
var left_text: String
var right_text: String
var left_title: String
var right_title: String
var left_representation: String
var right_representation: String
var definitions: Array[BijectionDefinition]
var hint: String
var proof: BijectionProof
var alternate_solutions: int = 0
var is_catalan: bool = false

# TODO: Descriptions of coded representation

func _init(id: Variant, left_title: String, right_title: String, left_description: String, right_description: String, bijections: Dictionary, left_generator: Callable = Callable(), right_generator: Callable = Callable(), left_representation: String = "", right_representation: String = "", definitions: Array[BijectionDefinition] = [], hint: String = "", proof: BijectionProof = BijectionProof.new(), alternate_solutions: int = 0, is_catalan: bool = false) -> void:
	self.id = id
	self.left_title = left_title
	self.left_text = left_description
	self.right_title = right_title
	self.right_text = right_description
	self.bijections = bijections
	self.left_generator = left_generator
	self.right_generator = right_generator
	self.left_representation = left_representation
	self.right_representation = right_representation
	self.definitions = definitions
	self.hint = hint
	self.proof = proof
	self.alternate_solutions = alternate_solutions
	self.is_catalan = is_catalan

static func from_catalan_problems(problem1: CatalanProblem, problem2: CatalanProblem) -> BijectionLevel:
	var bijections: Dictionary = {}
	var problem1_sizes: Dictionary = problem1.get_sizes_dict()
	var problem2_sizes: Dictionary = problem2.get_sizes_dict()
	if problem1_sizes.size() != problem2_sizes.size():
		print("Error: Problem sizes do not match. Problem 1 has %d sizes, Problem 2 has %d sizes" % [problem1_sizes.size(), problem2_sizes.size()])
		return null
	for size: int in problem1_sizes.keys():
		var from: Array[BijectionElement] = problem1_sizes[size] as Array[BijectionElement]
		var to: Array[BijectionElement] = problem2_sizes[size] as Array[BijectionElement]
		bijections[size] = Bijection.new(size, from, to)
	# TODO: Add proofs
	return BijectionLevel.new([problem1.id, problem2.id], problem1.title, problem2.title, problem1.description, problem2.description, bijections, problem1.generate_elements_code, problem2.generate_elements_code, problem1.representation, problem2.representation, problem1.definitions + problem2.definitions, "", BijectionProof.new(), 0, true)
