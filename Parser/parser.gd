extends Node

const KEYWORDS: Array[String] = ["return", "if", "then", "else", "endelse", "endif", "while", "do", "endwhile", "for", "in", "repeat", "times"]

# Runs the code. If you're running the same program multiple times, you can optimise this by first calling build_ast (once per program), and then running the same AST as many times as you need to.
# Returns the return value of the program, or null if there was an error. Error messages are printed to console.
static func parse(code: String, input: Variant = 0) -> Variant:
	# Obtain abstract syntax tree
	var ast: AST = ProgramAST.parse(code, 0)
	if ast is ErrorAST:
		print(ast.format_error(code))
		return

	print(" ---- EXECUTION ------")

	# Run AST on the given input
	var variables: Dictionary = {}
	variables["input"] = input
	var result: Dictionary = ast.execute(variables)

	if "%error%" in result:
		if "%error_pos%" in result:
			print(Parser.format_error(code, result["%error_pos%"], result["%error%"]))
		else:
			print("Error: " + result["%error%"])
		return
	elif "%return%" not in result:
		print("Error: No return statement found")
		return
	else:
		print("Return value: " + str(result["%return%"]))

	var retval: Variant = result["%return%"]
	return retval

# Builds an AST from a source program which can then be executed multiple times. The root may be an ErrorAST if there is a syntax error.
static func build_ast(code: String) -> AST:
	return ProgramAST.parse(code, 0)


static func is_letter(char: String) -> bool:
	return char in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

class AST:
	var end_pos: int = 0

	# Runs the AST. Outputs the variables. Key variables:
	#    %return% - Contains the return value. This may be empty if the user hasn't put a return statement - it is your responsibility to flag this as an error should you wish.
	#    %error% - Contains the error message, if there is one. This will span one line only, will not include the word "Error" and will not include the line number.
	#    %error_pos% - Contains the position of the error in the code. Use this and the error message in Parser.format_error to get a nice error message.
	func execute(variables: Dictionary) -> Dictionary:
		return variables
	
	static func parse(code: String, pos: int) -> AST:
		return ProgramAST.parse(code, pos)

class ProgramAST extends AST:
	static func parse(code: String, pos: int) -> AST:
		return BlockAST.parse(code, pos, "main")

class BlockAST extends AST:
	var statements: Array[AST]

	func _init(statements: Array[AST], end_pos: int = -1) -> void:
		self.statements = statements
		self.end_pos = end_pos

	static func parse(code: String, pos: int, block_type: String = "") -> AST:
		print("Parsing a new block of type " + block_type + " starting at: " + code.substr(pos, 10).replace("\n", "<NL>") + "...")
		var statements: Array[AST] = []
		while pos < len(code):
			print("Pos: " + str(pos) + ", code: " + code.substr(pos, 7).replace("\n", "<NL>") + "...")
			if code.substr(pos, 6) == "repeat":
				statements.push_back(RepeatStmtAST.parse(code, pos))
				pos = statements[-1].end_pos
				if statements[-1] is ErrorAST:
					return statements[-1]
			elif code.substr(pos, 5) == "while":
				statements.push_back(WhileStmtAST.parse(code, pos))
				pos = statements[-1].end_pos
				if statements[-1] is ErrorAST:
					return statements[-1]
			elif code.substr(pos, 3) == "for":
				statements.push_back(ForStmtAST.parse(code, pos))
				pos = statements[-1].end_pos
				if statements[-1] is ErrorAST:
					return statements[-1]
			elif code[pos] in [" ", "\n", "\t", "\r"]:
				pos += 1
			elif code.substr(pos, 2) == "//":
				pos = code.find("\n", pos)
			elif code.substr(pos, 2) == "if":
				statements.push_back(IfStmtAST.parse(code, pos))
				pos = statements[-1].end_pos
				if statements[-1] is ErrorAST:
					return statements[-1]
			elif code.substr(pos, 5) == "endif":
				if block_type == "if" or block_type == "else":
					# Do not consume the endif keyword - the if statement will check this and then consume it
					break
				else:
					return ErrorAST.new("Unexpected 'endif': not in if block", pos, pos+5)
			elif code.substr(pos, 4) == "else":
				if block_type == "if":
					# Do not consume the else keyword - the if statement needs to know what it ended on
					break
				else:
					return ErrorAST.new("Unexpected 'else': not in if block", pos, pos+4)
			elif code.substr(pos, 9) == "endrepeat":
				if block_type == "repeat":
					pos += 9
					break
				else:
					return ErrorAST.new("Unexpected 'endrepeat': not in repeat loop", pos, pos+9)
			elif code.substr(pos, 8) == "endwhile":
				if block_type == "while":
					pos += 8
					break
				else:
					return ErrorAST.new("Unexpected 'endwhile': not in while loop", pos, pos+8)
			elif code.substr(pos, 6) == "endfor":
				if block_type == "for":
					pos += 6
					break
				else:
					return ErrorAST.new("Unexpected 'endfor': not in for loop", pos, pos+6)
			elif code.substr(pos, 6) == "return":
				statements.push_back(ReturnStmtAST.parse(code, pos))
				if statements[-1] is ErrorAST:
					return statements[-1]
				pos = statements[-1].end_pos
			else:
				# Assignment or just an expression
				var end_pos: int = code.find("\n", pos)
				if end_pos == -1:
					end_pos = len(code)
				var line: String = code.substr(pos, end_pos-pos)
				print("Either assignment or expression: " + line)
				if line.find("<-", 0) == -1:
					statements.push_back(ExprLineAST.parse_line(line, pos))
				else:
					statements.push_back(AssignLineAST.parse_line(line, pos))
				if statements[-1] is ErrorAST:
					return statements[-1]
				pos = end_pos
		print("Exiting " + block_type + " block at pos: " + str(pos) + ", leaving code: " + code.substr(pos, 7).replace("\n", "<NL>") + "...")
		return BlockAST.new(statements, pos)

	func execute(variables: Dictionary) -> Dictionary:
		for stmt: AST in self.statements:
			variables = stmt.execute(variables)
			if "%return%" in variables or "%error%" in variables:
				break
		return variables
			
class StmtAST extends AST:
	pass

class IfStmtAST extends StmtAST:
	var expr: ExprLineAST
	var block: AST
	var else_block: AST

	func _init(expr: ExprLineAST, block: AST, else_block: AST, end_pos: int = -1) -> void:
		self.expr = expr
		self.block = block
		self.else_block = else_block
		self.end_pos = end_pos

	static func parse(code: String, pos: int) -> AST:
		var then_pos: int = code.find("then", pos+2)
		if then_pos == -1:
			return ErrorAST.new("Expected 'then' after 'if' expression", pos, pos+2)
		var expr: ExprLineAST = ExprLineAST.parse_line(code.substr(pos+2, then_pos-pos-2), pos+2)
		var block: AST = BlockAST.parse(code, then_pos+4, "if")
		if block is ErrorAST:
			return block
		if code.substr(block.end_pos, 4) == "else":
			var else_pos: int = block.end_pos
			var else_block: AST = BlockAST.parse(code, else_pos+4, "else")
			if else_block is ErrorAST:
				return else_block
			return IfStmtAST.new(expr, block, else_block, else_block.end_pos+len("endif"))
		else:
			return IfStmtAST.new(expr, block, BlockAST.new([]), block.end_pos+len("endif"))

	func execute(variables: Dictionary) -> Dictionary:
		variables = self.expr.execute(variables)
		if "%error%" in variables:
			return variables
		if variables["%result%"]:
			variables = self.block.execute(variables)
		else:
			variables = self.else_block.execute(variables)
		return variables

class WhileStmtAST extends StmtAST:
	var expr: ExprLineAST
	var block: AST

	func _init(expr: ExprLineAST, block: AST, end_pos: int = -1) -> void:
		self.expr = expr
		self.block = block
		self.end_pos = end_pos

	static func parse(code: String, pos: int) -> AST:
		var expr_end: int = code.find("do", pos+6)
		if expr_end == -1:
			return ErrorAST.new("'while' should be followed by an expression and then the word 'do'", pos, pos+6)
		var expr: ExprLineAST = ExprLineAST.parse_line(code.substr(pos+6, expr_end-pos-6), pos+6)
		var block: AST = BlockAST.parse(code, expr_end+2, "while")
		if block is ErrorAST:
			return block
		return WhileStmtAST.new(expr, block, block.end_pos)

	func execute(variables: Dictionary) -> Dictionary:
		variables = self.expr.execute(variables)
		var count: int = 0
		while variables["%result%"]:
			variables = self.block.execute(variables)
			if "%return%" in variables or "%error%" in variables:
				break
			variables = self.expr.execute(variables)
			count += 1
			if count > 1000:
				variables["%error%"] = "Infinite loop detected"
				variables["%error_pos%"] = self.expr.end_pos - len(self.expr.literal)
				variables["%error_pos_end%"] = self.expr.end_pos
				break
		return variables

class ForStmtAST extends StmtAST:
	var ident: String
	var expr: ExprLineAST
	var block: AST

	func _init(ident: String, expr: ExprLineAST, block: AST, end_pos: int = -1) -> void:
		self.ident = ident
		self.expr = expr
		self.block = block
		self.end_pos = end_pos

	static func parse(code: String, pos: int) -> AST:
		var in_pos: int = code.find("in", pos+4)
		if in_pos == -1:
			return ErrorAST.new("Expected 'in' after 'for'. Syntax is 'for VARIABLE in ITERABLE do CODE endfor'", pos, pos+4)
		var ident: String = code.substr(pos+4, in_pos-pos-4).strip_edges()
		if not ident.is_valid_identifier():
			return ErrorAST.new("Invalid identifier: " + ident, pos+4, in_pos)
		var do_pos: int = code.find("do", in_pos+2)
		if do_pos == -1:
			return ErrorAST.new("Expecting the word 'do' after the expression in a 'for' loop", in_pos, in_pos+2)
		var expr: ExprLineAST = ExprLineAST.parse_line(code.substr(in_pos+2, do_pos-in_pos-2), in_pos+2)
		var block: AST = BlockAST.parse(code, do_pos+2, "for")
		if block is ErrorAST:
			return block
		return ForStmtAST.new(ident, expr, block, block.end_pos)

	func execute(variables: Dictionary) -> Dictionary:
		variables = self.expr.execute(variables)
		if "%error%" in variables:
			return variables
		var iterable: Variant = variables["%result%"]
		for val: Variant in iterable:
			variables[self.ident] = val
			variables = self.block.execute(variables)
			if "%return%" in variables or "%error%" in variables:
				break
		return variables

class RepeatStmtAST extends StmtAST:
	var expr: ExprLineAST
	var block: AST

	func _init(expr: ExprLineAST, block: AST, end_pos: int = -1) -> void:
		self.expr = expr
		self.block = block
		self.end_pos = end_pos

	static func parse(code: String, pos: int) -> AST:
		var expr_end: int = code.find("times", pos+6)
		if expr_end == -1:
			return ErrorAST.new("'repeat' should be followed by an expression and then the word 'times'", pos, pos+6)
		var expr: ExprLineAST = ExprLineAST.parse_line(code.substr(pos+6, expr_end-pos-6), expr_end)
		var block: AST = BlockAST.parse(code, expr_end+5, "repeat")
		if block is ErrorAST:
			return block
		return RepeatStmtAST.new(expr, block, block.end_pos)

	func execute(variables: Dictionary) -> Dictionary:
		variables = self.expr.execute(variables)
		var count: int = variables["%result%"]
		for i: int in range(count):
			variables["i"] = i+1
			variables = self.block.execute(variables)
			if "%return%" in variables or "%error%" in variables:
				break
		return variables

class LineAST extends AST:
	static func parse(code: String, pos: int) -> AST:
		return ErrorAST.new("LineAST should be parsed with parse_line instead", pos, pos+10)

class AssignLineAST extends LineAST:
	var ident: String
	var index: ExprLineAST
	var expr: ExprLineAST

	func _init(ident: String, expr: ExprLineAST, index: ExprLineAST = null) -> void:
		self.ident = ident
		self.index = index
		self.expr = expr
		self.end_pos = end_pos

	static func parse_line(line: String, pos: int) -> AST:
		print("Parsing assignment: " + line)
		var arrow_pos: int = line.find("<-")
		if arrow_pos == -1:
			return ErrorAST.new("Expecting a statement of the form 'identifier <- expression'", pos, pos+len(line))
		var ident: String = line.substr(0, arrow_pos).strip_edges()
		var index: ExprLineAST = null
		if ident.contains("[") and ident.ends_with("]"):
			index = ExprLineAST.parse_line(ident.substr(ident.find("[")+1, ident.find("]")-ident.find("[")-1), pos)
			ident = ident.substr(0, ident.find("["))
		if not ident.is_valid_identifier():
			return ErrorAST.new("Invalid identifier: " + ident, pos, pos+arrow_pos)
		var expr: ExprLineAST = ExprLineAST.parse_line(line.substr(arrow_pos+2), pos+arrow_pos+2)
		return AssignLineAST.new(ident, expr, index)

	func execute(variables: Dictionary) -> Dictionary:
		variables = expr.execute(variables)
		if "%error%" in variables:
			return variables
		var value: Variant = variables["%result%"]
		if self.index != null:
			variables = self.index.execute(variables)
			if "%error%" in variables:
				return variables
			var index: Variant = variables["%result%"]
			if self.ident not in variables:
				variables["%error%"] = "Undefined variable: " + self.ident
				variables["%error_pos%"] = self.end_pos-len(self.ident)
				variables["%error_pos_end%"] = self.end_pos
				return variables
			if typeof(variables[self.ident]) not in [TYPE_ARRAY, TYPE_DICTIONARY]:
				variables["%error%"] = "Variable is not an array or dictionary: " + self.ident
				variables["%error_pos%"] = self.end_pos-len(self.ident)
				variables["%error_pos_end%"] = self.end_pos
				return variables
			if typeof(variables[self.ident]) == TYPE_ARRAY:
				if typeof(index) != TYPE_INT:
					variables["%error%"] = "Array index must be an integer"
					variables["%error_pos%"] = self.end_pos-len(self.ident)
					variables["%error_pos_end%"] = self.end_pos
					return variables
				if index >= len(variables[self.ident]):
					variables["%error%"] = "Index out of bounds: " + str(index) + " (length is " + str(len(variables[self.ident])) + " so max index is " + str(len(variables[self.ident])-1) + ")"
					variables["%error_pos%"] = self.end_pos-len(self.ident)
					variables["%error_pos_end%"] = self.end_pos
					return variables
			print("Before: " + str(variables))
			variables[self.ident][index] = value
			print("After: " + str(variables))
		else:
			variables[self.ident] = value
		return variables

class ReturnStmtAST extends AST:
	var expr: ExprLineAST

	func _init(expr: ExprLineAST, end_pos: int = -1) -> void:
		self.expr = expr
		self.end_pos = end_pos

	static func parse(code: String, pos: int) -> AST:
		var end_pos: int = code.find("\n", pos+1)
		if end_pos == -1:
			end_pos = len(code)
		print("Return statement starting at: " + str(pos) + " and ending at: " + str(end_pos) + ", in total: \"" + code.substr(pos, end_pos-pos) + "\"")
		var expr: ExprLineAST = ExprLineAST.parse_line(code.substr(pos+6, end_pos-pos-6), pos+6)
		return ReturnStmtAST.new(expr, end_pos)

	func execute(variables: Dictionary) -> Dictionary:
		variables = self.expr.execute(variables)
		variables["%return%"] = variables["%result%"]
		return variables

class ExprLineAST extends LineAST:
	var literal: String

	func _init(text: String, end_pos: int = 0) -> void:
		self.literal = text.strip_edges()
		self.end_pos = end_pos

	static func parse_line(line: String, pos: int) -> AST:
		return ExprLineAST.new(line, pos+len(line))

	func execute(variables: Dictionary) -> Dictionary:
		# Execute using GDScript built-in class
		print("Evaluating the expression: \"" + self.literal + "\" with variables: " + str(variables))
		var expression: Expression = Expression.new()
		var error: Error = expression.parse(self.literal, variables.keys())
		if error != OK:
			if expression.get_error_text() == "Expected '='":
				variables["%error%"] = "(Parsing expression) Unexpected '='. Did you mean '==' (for testing equality) or '<-' (for assignment)?"
			elif expression.get_error_text().contains("instance is null (not passed)"):
				variables["%error%"] = "(Parsing expression) Undefined variable"
			else:
				variables["%error%"] = "(Parsing expression) " + expression.get_error_text()
			variables["%error_pos%"] = self.end_pos-len(self.literal)
			variables["%error_pos_end%"] = self.end_pos
			variables["%result%"] = null
			return variables
		var result: Variant = expression.execute(variables.values())
		if expression.has_execute_failed():
			if expression.get_error_text().contains("instance is null (not passed)"):
				variables["%error%"] = "(Executing expression) Undefined variable"
			else:
				variables["%error%"] = "(Executing expression) " + expression.get_error_text()
			variables["%error%"] = "(In expression) " + expression.get_error_text()
			variables["%error_pos%"] = self.end_pos-len(self.literal)
			variables["%error_pos_end%"] = self.end_pos
			variables["%result%"] = null
			return variables
		print("Result: " + str(result))
		variables["%result%"] = result
		return variables

class ErrorAST extends AST:
	var error_text: String = ""
	var start_pos: int = 0

	func _init(error_text: String, start_pos: int, end_pos: int) -> void:
		print("Error: " + error_text)
		self.error_text = error_text
		self.end_pos = end_pos
		self.start_pos = start_pos

	func format_error(code: String) -> String:
		return Parser.format_error(code, start_pos, self.error_text)


func get_line_and_col(code: String, pos: int) -> Vector2:
	var line: int = 1
	var col: int = 1
	for i: int in range(pos):
		if code[i] == "\n":
			line += 1
			col = 1
		else:
			col += 1
	# print("Pos: " + str(pos) + " translated into line: " + str(line) + ", col: " + str(col))
	return Vector2(line, col)

func format_error(code: String, pos: int, error_text: String) -> String:
	# Determine which line the error is on
	var line_col: Vector2 = Parser.get_line_and_col(code, pos)
	var line: int = line_col.x
	var col: int = line_col.y
	var line_start: int = code.rfind("\n", pos)
	if line_start == -1:
		line_start = 0
	var line_end: int = code.find("\n", pos)
	if line_end == -1:
		line_end = len(code)

	var error_message: String = "Error on line " + str(line) + ": " + code.substr(line_start, line_end-line_start) + "\n"
	for i: int in range(col-1):
		error_message += " "
	error_message += "^\n" + error_text + "\n"
	return error_message

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
