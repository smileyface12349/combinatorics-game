extends Node

const KEYWORDS: Array[String] = ["return", "if", "then", "else", "endif", "while", "do", "endwhile", "for", "in", "push", "pop", "into", "from", "at"]
const OPERATORS: Array[String] = ["or", "and", "not", "=", "<", "<=", ">", ">=", "+", "-", "*", "/"]
const MISCELLANEOUS: Array[String] = ["[", "]", "(", ")", "<-", ";", ","]

static func parse(code: String, input: Variant = 0) -> void:
	var tokens: Array[Token] = lexer(code)
	print("Tokens: " + str(tokens))


static func lexer(code: String) -> Array[Token]:
	var pos: int = 0
	var tokens: Array[Token] = []

	while pos < len(code):
		# Attempt an exact match
		var match_found: bool = false
		for keyword: String in KEYWORDS + OPERATORS + MISCELLANEOUS:
			var has_match: bool = true
			for index: int in range(len(keyword)):
				if keyword[index] != code[pos+index]:
					has_match = false
					break
			if has_match:
				tokens.append(Token.new(code.substr(pos, len(keyword))))
				pos += len(keyword)
				match_found = true
				break
		if match_found:
			continue

		# Attempt to match identifiers
		if is_letter(code[pos]):
			# Match longest identifier
			var length: int = 1
			while pos+length < len(code) and is_letter(code[pos+1]):
				length += 1
			tokens.append(Token.new(code.substr(pos, length), TokenType.IDENTIFIER))
			pos += length
			continue

		# TODO: Match literals

		# Now allow whitespace
		if code[pos] in [" ", "\n"]:
			pos += 1
			continue
		
		# TODO: Comments

		# If nothing else matched, it's an error
		return []

	return tokens


static func is_letter(char: String) -> bool:
	return char in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

class Token:
	var literal: String
	var type: TokenType

	func _init(literal: String, type: TokenType = TokenType.EXACT) -> void:
		self.literal = literal
		self.type = type

	func _to_string() -> String:
		if self.type == TokenType.EXACT:
			return "<" + self.literal + ">"
		elif self.type == TokenType.NUMBER:
			return "<NUM, " + self.literal + ">"
		else:
			return "<IDENT, " + self.literal + ">"


enum TokenType {
	NUMBER,
	IDENTIFIER,
	EXACT
}