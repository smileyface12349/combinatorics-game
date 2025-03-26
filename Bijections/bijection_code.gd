extends Node
class_name BijectionCodeNode


@export var testInput: TextEdit
@export var testOutput: RichTextLabel
@export var testButton: Button
@export var codeInput: CodeEdit
@export var extendedOutput: RichTextLabel

@export var insertIf: Button
@export var insertIfElse: Button
@export var insertWhile: Button
@export var insertFor: Button
@export var insertRepeat: Button


func _ready() -> void:
	testButton.pressed.connect(test_code)
	
	for keyword: String in ['return', 'if', 'then', 'else', 'endif', 'while', 'do', 'endwhile', 'for', 'in', 'endfor', 'repeat', 'times', 'endrepeat']:
		codeInput.syntax_highlighter.add_keyword_color(keyword, Color.ORANGE)
	codeInput.syntax_highlighter.add_color_region("//", "", Color.BLACK)

	# Fiddly focus stuff
	codeInput.focus_entered.connect(text_focus_entered)
	codeInput.focus_exited.connect(text_focus_exited)
	codeInput.mouse_entered.connect(code_mouse_entered)
	codeInput.mouse_exited.connect(code_mouse_exited)
	testInput.focus_entered.connect(text_focus_entered)
	testInput.focus_exited.connect(text_focus_exited)
	testInput.mouse_entered.connect(test_mouse_entered)
	testInput.mouse_exited.connect(test_mouse_exited)
	for insertButton: Button in [insertIf, insertIfElse, insertWhile, insertFor, insertRepeat, testButton]:
		insertButton.mouse_entered.connect(insert_button_mouse_entered)
		insertButton.mouse_exited.connect(insert_button_mouse_exited)

	# Insert buttons
	insertIf.pressed.connect(insert_if)
	insertIfElse.pressed.connect(insert_if_else)
	insertWhile.pressed.connect(insert_while)
	insertFor.pressed.connect(insert_for)
	insertRepeat.pressed.connect(insert_repeat)

	codeInput.mouse_exited.connect(code_mouse_exited)
	codeInput.mouse_entered.connect(code_mouse_entered)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		on_mouse_click()

func set_level(level: BijectionLevel) -> void:
	pass

# CODE EXECUTION

func test_code() -> void:
	# Parse the input to get it in the right data type
	var expression: Expression = Expression.new()
	var error: Error = expression.parse(testInput.text)
	if error != OK:
		display_error(expression.get_error_text(), 0, 0, "Input Error")
		return
	var input: Variant = expression.execute()
	if expression.has_execute_failed():
		display_error(expression.get_error_text(), 0, 0, "Input Error")
		return

	# Build the AST from the source program
	var ast: Parser.AST = Parser.build_ast(codeInput.text)
	if ast is Parser.ErrorAST:
		display_error(Parser.format_error(codeInput.text, ast.start_pos, ast.error_text), ast.start_pos, ast.end_pos, "Syntax Error")
		return

	# Run the code on the AST
	var variables: Dictionary = Parser.run_ast(ast, input)
	if "%error%" in variables:
		if "%error_pos%" in variables:
			if "%error_pos_end%" not in variables:
				variables["%error_pos_end%"] = variables["%error_pos%"]
			display_error(Parser.format_error(codeInput.text, variables["%error_pos%"], variables["%error%"]), variables["%error_pos%"], variables["%error_pos_end%"])
		else:
			display_error(variables["%error%"], 0, 0)
		return
	elif "%return%" not in variables:
		display_error("No return statement found", 0, 0)
		return
	
	# Display the output
	testOutput.text = "Output: " + str(variables["%return%"])
	extendedOutput.text = ""


func display_error(error: String, start_pos: int = 0, end_pos: int = 0, error_title: String = "Error") -> void:
	testOutput.text = "Output: [color=red]" + error_title + "[/color]"
	extendedOutput.text = error_title + ": " + error
	var start_line_col: Vector2 = Parser.get_line_and_col(codeInput.text, start_pos)
	var end_line_col: Vector2 = Parser.get_line_and_col(codeInput.text, end_pos)
	codeInput.select(start_line_col.x-1, start_line_col.y-1, end_line_col.x-1, end_line_col.y-1)


func insert_code(text: String, highlight_start: int, highlight_end: int) -> void:
	# Get caret position
	var line: int = codeInput.get_caret_line()
	var column: int = codeInput.get_caret_column()

	# Test if it's at the beginning of a line or an indent
	var line_text: String = codeInput.get_line(line)
	if column == 0 or line_text[column - 1] == ' ':
		# Insert right here
		pass
	else:
		# Add a new line first
		codeInput.insert_text("\n", line, column)
		line += 1
		column = 0

	# Insert statement at the caret position
	codeInput.insert_text(text, line, column)

	# Highlight the inserted text
	codeInput.select(line, column + highlight_start, line, column + highlight_end)

func insert_if() -> void:
	insert_code("if CONDITION then\n	// Your code here\nendif\n", 3, 12)

func insert_if_else() -> void:
	insert_code("if CONDITION then\n	// Your code here\nelse\n	// Your code here\nendif\n", 3, 12)

func insert_while() -> void:
	insert_code("while CONDITION do\n	// Your code here\nendwhile\n", 6, 15)

func insert_for() -> void:
	insert_code("for VARIABLE in EXPRESSION do\n	// Your code here\nendfor\n", 4, 13)

func insert_repeat() -> void:
	insert_code("repeat EXPRESSION times\n	// Your code here\nendrepeat\n", 7, 16)


# Lots of fiddly stuff to manage the focus
# Focus is lost when the (left) mouse button is clicked outside the element

var is_mouse_over_code: bool = false
var is_mouse_over_test: bool = false
var is_mouse_over_insert: bool = false

func code_mouse_exited() -> void:
	is_mouse_over_code = false
func code_mouse_entered() -> void:
	is_mouse_over_code = true

func test_mouse_exited() -> void:
	is_mouse_over_test = false
func test_mouse_entered() -> void:
	is_mouse_over_test = true

func insert_button_mouse_entered() -> void:
	is_mouse_over_insert = true
func insert_button_mouse_exited() -> void:
	is_mouse_over_insert = false

func text_focus_entered() -> void:
	GeneralSettings.is_popup_open = true

func text_focus_exited() -> void:
	GeneralSettings.is_popup_open = false


func on_mouse_click() -> void:
	return
	if is_mouse_over_insert:
		# Don't lose focus if we're clicking on the insert buttons
		return

	# Lose focus on anything we're not hovering over
	if not is_mouse_over_code and codeInput.has_focus():
		codeInput.release_focus()
	if not is_mouse_over_test and codeInput.has_focus():
		testInput.release_focus()
