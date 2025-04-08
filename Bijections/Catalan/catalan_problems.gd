extends Node
class_name CatalanProblems

var PROBLEMS: Dictionary = {
	0: CatalanParentheses.new(),
	1: CatalanDyckPaths.new(),
	2: CatalanBinaryTrees.new(),
	# 3: CatalanTriangulations.new(),
	4: CatalanMotzkinPathsColoured.new()
}