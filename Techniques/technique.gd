extends Node

# ABSTRACT CLASSES

# An abstract problem to be solved using techniques. Please use the correct class overriding this
# depending on what form the solution to the problem will take.
class Problem:
	var text: String
	
# A problem with a numerical answer
class IntProblem extends Problem:
	var overcount_problems: Array[OvercountProblem] = []
	var complement_problem: ComplementProblem = null
	var incorrect_complement_problems: Array[String] = ["How many chickens cross the road each day?"]
	var solution: IntSolution
	
	# Function to validate solution. This can be overriden to allow for multiple solutions.
	func validateSolution(solution: IntSolution) -> bool:
		return solution == self.solution
		
	func _init(text: String, solution: IntSolution) -> void:
		self.text = text
		self.solution = solution
	
# A problem with a formula answer
class FormulaProblem extends Problem:
	var solution: FormulaSolution
	
	# Function to validate solution. This can be overriden to allow for multiple solutions.
	func validateSolution(solution: FormulaSolution) -> bool:
		return solution == self.solution
		
	func _init(text: String, solution: FormulaSolution) -> void:
		self.text = text
		self.solution = solution

# A solution to a problem
class ProblemSolution:
	func display() -> String:
		return "ERROR"
	
# A numerical solution to a problem
class IntSolution extends ProblemSolution:
	var num: int
	
	func display() -> String:
		return str(num)
		
	func _init(num: int) -> void:
		self.num = num
		
# A formula solution to a problem
class FormulaSolution extends ProblemSolution:
	# TODO: Parse formula and store it in a parsed form.
	var formula: String
	
	func display() -> String:
		return formula
		
	func _init(formula: String) -> void:
		self.formula = formula
		

# Contains all the information for a technique
class Technique:
	var title: String
	var description: String = ""
	var sub_problems: Array[Problem]
	
# A technique that transforms an integer problem into a new integer problem
class IntProblemTechnique extends Technique:
	var input_problem: IntProblem
	var new_problem: IntProblem
	
# A technique that transforms a formula problem into a new formula problem
class FormulaProblemTechnique extends Technique:
	var input_problem: FormulaProblem
	var new_problem: FormulaProblem

# A technique that solves an integer problem to produce a final answer
class IntSolutionTechnique extends Technique:
	var input_problem: IntProblem
	var solution: IntSolution
	
# A technique that solves a formula problem to produce a final answer
class FormulaSolutionTechnique extends Technique:
	var input_problem: FormulaProblem
	var solution: FormulaSolution
	

# UI ELEMENTS

class ComponentScreen:
	var title: String
	var elements: Array[ComponentElement]
	
class ComponentElement:
	func display() -> void:
		pass # todo
		
class InputElement extends ComponentElement:
	pass # TODO
	
# TECHNIQUES

# Overcounting:
# 	INPUT: IntProblem (something to be counted)
#	SUBPROBLEMS: IntProblem (how much does it overcount by)
#	OUTPUT: IntProblem (a new, hopefully simpler, problem)
class Overcount extends IntProblemTechnique:
	func _init(input_problem: IntProblem) -> void:
		self.title = "Overcount"
		self.description = "Transform this problem into a simpler problem, then remove overcounting later."
		self.input_problem = input_problem
		
	func choose_problem(problem: OvercountProblem) -> void:
		self.sub_problems = [problem.overcounts_by]
		self.new_problem = problem.new_problem
	
# A possible problem to be chosen in the overcount menu. Hardcoded for each problem.
# The problem for how much it overcounts by should have a solution built-in.
class OvercountProblem:
	var new_problem: IntProblem
	var overcounts_by: IntProblem
	
	func _init(new_problem: IntProblem, overcounts_by: int, 
		subproblem_text: String = "How much does this problem overcount compared to the original problem?"
	) -> void:
		self.new_problem = new_problem
		self.overcounts_by = IntProblem.new(
			subproblem_text,
			IntSolution.new(overcounts_by)
		)
		
# Consider Complement
#	INPUT: IntProblem (something to be counted)
#	SUBPROBLEMS: IntProblem (the total for the general case)
#	OUTPUT: IntProblem (the problem for counting the complement)
class Complement extends IntProblemTechnique:
	func _init(input_problem: IntProblem) -> void:
		self.input_problem = input_problem
		self.title = "Consider the Complement"
		self.description = "Consider the complement of the set you are trying to compute, then subtract this from the total possibilities."
		
	# Only call this when the correct problem is chosen. There are lots of incorrect answers provided
	# as strings only (since they don't actually make any sense).
	func choose_problem() -> void:
		if self.input_problem.complement_problem != null:
			self.sub_problems = [self.input_problem.complement_problem.total]
			self.new_problem = self.input_problem.complement_problem.complement
	
# Information about how to use the complement of a problem. There is only ever one correct answer.
class ComplementProblem:
	var complement: IntProblem
	var total: IntProblem
	
	func _init(complement: IntProblem, total: IntProblem) -> void:
		self.complement = complement
		self.total = total
		



# TODO: Display the blocks for overcounting and consider complements
# TODO: Bring this together to form a simple level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
