extends Node

const KEYWORDS: Array[String] = ["return", "if", "then", "else", "endelse", "endif", "while", "do", "endwhile", "for", "in", "repeat", "times"]

static func parse(code: String, input: Variant = 0) -> void:
	# Obtain abstract syntax tree
	var ast: AST = ProgramAST.parse(code)
	if ast is ErrorAST:
		print("Error parsing code: " + ast.error_text)
		return

	print(" ---- EXECUTION ------")

	# Run AST on the given input
	var variables: Dictionary = {}
	var result: Dictionary = ast.execute(variables)

	if "%error%" in result:
		print("Error: " + result["%error%"])
		return
	elif "%return%" not in result:
		print("Error: No return statement found")
		return
	else:
		print("Return value: " + str(result["%return%"]))

	var retval: Variant = result["%return%"]



static func is_letter(char: String) -> bool:
	return char in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

class AST:
	var end_pos: int = 0

	func execute(variables: Dictionary) -> Dictionary:
		return variables
	
	static func parse(code: String, pos: int = 0) -> AST:
		return ProgramAST.parse(code, pos)

class ProgramAST extends AST:
	static func parse(code: String, pos: int = 0) -> AST:
		return BlockAST.parse(code, pos)

class BlockAST extends AST:
	var statements: Array[AST]

	func _init(statements: Array[AST], end_pos: int = -1) -> void:
		self.statements = statements
		self.end_pos = end_pos

	static func parse(code: String, pos: int = 0, block_type: String = "") -> AST:
		print("Parsing block starting at: " + code.substr(pos, 10))
		var statements: Array[AST] = []
		while pos < len(code):
			if code.substr(pos, 6) == "repeat":
				statements.push_back(RepeatStmtAST.parse(code, pos))
				pos = statements[-1].end_pos
				if statements[-1] is ErrorAST:
					return statements[-1]
				print("The rest of the code: " + code.substr(pos, 10))
			# TODO: Other statments
			elif code[pos] in [" ", "\n", "\t", "\r"]:
				pos += 1
			elif code.substr(pos, 9) == "endrepeat":
				if block_type == "repeat":
					pos += 9
					break
				else:
					return ErrorAST.new("Unexpected 'endrepeat' statement")
			elif code.substr(pos, 6) == "return":
				statements.push_back(ReturnStmtAST.parse(code, pos))
				if statements[-1] is ErrorAST:
					return statements[-1]
				pos = statements[-1].end_pos
			elif Parser.is_letter(code[pos]):
				statements.push_back(AssignStmtAST.parse(code, pos))
				if statements[-1] is ErrorAST:
					return statements[-1]
				print("Old pos: " + str(pos) + ", new pos: " + str(statements[-1].end_pos))
				pos = statements[-1].end_pos
			else:
				return ErrorAST.new("Unexpected character: " + code[pos])
		print("Returning block with end pos: " + str(pos))
		return BlockAST.new(statements, pos)

	func execute(variables: Dictionary) -> Dictionary:
		for stmt: AST in self.statements:
			variables = stmt.execute(variables)
			if "%return%" in variables or "%error%" in variables:
				break
		return variables
			
class StmtAST extends AST:
	pass

class RepeatStmtAST extends StmtAST:
	var expr: ExprAST
	var block: AST

	func _init(expr: ExprAST, block: AST, end_pos: int = -1) -> void:
		self.expr = expr
		self.block = block
		self.end_pos = end_pos

	static func parse(code: String, pos: int = 0) -> AST:
		var expr_end: int = code.findn("times", pos+6)
		if expr_end == -1:
			return ErrorAST.new("'repeat' should be followed by an expression and then the word 'times'")
		print("Code in body of repeat: " + code.substr(expr_end+5, 10))
		var expr: ExprAST = ExprAST.new(code.substr(pos+6, expr_end-pos))
		print("About to start parsing block starting at: " + code.substr(expr_end+5, 10))
		var block: AST = BlockAST.parse(code, expr_end+5, "repeat")
		print("Got the block. Returning repeat statement with end pos " + str(block.end_pos))
		return RepeatStmtAST.new(expr, block, block.end_pos)

	func execute(variables: Dictionary) -> Dictionary:
		variables = self.expr.execute(variables)
		var count: int = variables["%result%"]
		for i: int in range(count):
			variables["iteration_number"] = i
			variables = self.block.execute(variables)
			if "%return%" in variables or "%error%" in variables:
				break
		return variables

class AssignStmtAST extends StmtAST:
	var ident: String
	var expr: ExprAST

	func _init(ident: String, expr: ExprAST, end_pos: int = -1) -> void:
		self.ident = ident
		self.expr = expr
		self.end_pos = end_pos

	static func parse(code: String, pos: int = 0) -> AST:
		var end_pos: int = code.findn("\n", pos)+1
		if end_pos == -1:
			end_pos = len(code)
		print("Parsing assignment: " + code.substr(pos, end_pos-pos))
		var arrow_pos: int = code.findn("<-", pos)
		if arrow_pos == -1 or arrow_pos >= end_pos:
			return ErrorAST.new("Expecting a statement of the form 'identifier <- expression'")
		var ident: String = code.substr(pos, arrow_pos-pos).strip_edges()
		var expr: ExprAST = ExprAST.new(code.substr(arrow_pos+2))
		return AssignStmtAST.new(ident, expr, end_pos)

	func execute(variables: Dictionary) -> Dictionary:
		variables = expr.execute(variables)
		if "%error%" in variables:
			return variables
		variables[ident] = variables["%result%"]
		return variables

class ReturnStmtAST extends AST:
	var expr: ExprAST

	func _init(expr: ExprAST, end_pos: int = -1) -> void:
		self.expr = expr
		self.end_pos = end_pos

	static func parse(code: String, pos: int = 0) -> AST:
		print("Parsing return statement starting at: " + code.substr(pos, 10))
		var end_pos: int = code.findn("\n", pos+1)
		if end_pos == -1:
			end_pos = len(code)
		print("Start pos is: " + str(pos) + "End pos is: " + str(end_pos) + ", final return statement is: " + code.substr(pos, end_pos-pos))
		var expr: ExprAST = ExprAST.new(code.substr(pos+6, end_pos-pos-6))
		return ReturnStmtAST.new(expr, end_pos)

	func execute(variables: Dictionary) -> Dictionary:
		variables = self.expr.execute(variables)
		variables["%return%"] = variables["%result%"]
		return variables

class ExprAST extends AST:
	var literal: String

	func _init(text: String) -> void:
		self.literal = text

	func execute(variables: Dictionary) -> Dictionary:
		# Execute using GDScript built-in class
		print("Evaluating the expression: \"" + self.literal + "\" with variables: " + str(variables))
		var expression: Expression = Expression.new()
		expression.parse(self.literal, variables.keys())
		var result: Variant = expression.execute(variables.values())
		if expression.has_execute_failed():
			variables["%error%"] = "Error evaluating expression: " + self.literal + ", error: " + expression.get_error_text()
			variables["%result%"] = null
			return variables
		print("Result: " + str(result))
		variables["%result%"] = result
		return variables

class ErrorAST extends AST:
	var error_text: String = ""
	func _init(error_text: String) -> void:
		print("Error: " + error_text)
		self.error_text = error_text
		self.end_pos = 10000


# const KEYWORDS: Array[String] = ["return", "if", "then", "else", "endif", "while", "do", "endwhile", "for", "in", "push", "pop", "into", "from", "at"]
# const OPERATORS: Array[String] = ["or", "and", "not", "=", "<", "<=", ">", ">=", "+", "-", "*", "/"]
# const MISCELLANEOUS: Array[String] = ["[", "]", "(", ")", "<-", ";", ","]

# static func parse(code: String, input: Variant = 0) -> void:
# 	var tokens: Array[Token] = lexer(code)
# 	print("Tokens: " + str(tokens))


# static func lexer(code: String) -> Array[Token]:
# 	var pos: int = 0
# 	var tokens: Array[Token] = []

# 	while pos < len(code):
# 		# Attempt an exact match
# 		var match_found: bool = false
# 		for keyword: String in KEYWORDS + OPERATORS + MISCELLANEOUS:
# 			var has_match: bool = true
# 			for index: int in range(len(keyword)):
# 				if keyword[index] != code[pos+index]:
# 					has_match = false
# 					break
# 			if has_match:
# 				tokens.append(Token.new(code.substr(pos, len(keyword))))
# 				pos += len(keyword)
# 				match_found = true
# 				break
# 		if match_found:
# 			continue

# 		# Attempt to match identifiers
# 		if is_letter(code[pos]):
# 			# Match longest identifier
# 			var length: int = 1
# 			while pos+length < len(code) and is_letter(code[pos+1]):
# 				length += 1
# 			tokens.append(Token.new(code.substr(pos, length), TokenType.IDENTIFIER))
# 			pos += length
# 			continue

# 		# TODO: Match literals

# 		# Now allow whitespace
# 		if code[pos] in [" ", "\n"]:
# 			pos += 1
# 			continue
		
# 		# TODO: Comments

# 		# If nothing else matched, it's an error
# 		return []

# 	return tokens


# static func is_letter(char: String) -> bool:
# 	return char in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

# class Token:
# 	var literal: String
# 	var type: TokenType

# 	func _init(literal: String, type: TokenType = TokenType.EXACT) -> void:
# 		self.literal = literal
# 		self.type = type

# 	func _to_string() -> String:
# 		if self.type == TokenType.EXACT:
# 			return "<" + self.literal + ">"
# 		elif self.type == TokenType.NUMBER:
# 			return "<NUM, " + self.literal + ">"
# 		else:
# 			return "<IDENT, " + self.literal + ">"


# enum TokenType {
# 	NUMBER,
# 	IDENTIFIER,
# 	EXACT
# }
