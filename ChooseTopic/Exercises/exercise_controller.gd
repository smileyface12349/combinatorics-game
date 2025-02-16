extends Node
class_name ExerciseController

@export var menuButton: Button
@export var titleNode: RichTextLabel
@export var descriptionNode: RichTextLabel
@export var definitionsNode: RichTextLabel
@export var textInputNode: TextEdit
@export var checkButtonNode: Button
@export var feedbackTextNode: RichTextLabel

var exercise: Exercise

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkButtonNode.connect("pressed", check)
	textInputNode.connect("text_changed", text_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_exercise(exercise: Exercise, on_close: Callable) -> void:
	self.exercise = exercise
	menuButton.connect("pressed", on_close)
	titleNode.text = "[center]Bonus Problem " + str(exercise.id)
	descriptionNode.text = exercise.description
	if exercise.definitions.is_empty():
		definitionsNode.text = "No definitions"
	else:
		definitionsNode.text = "\n".join(exercise.definitions)
	feedbackTextNode.text = ""


func check() -> void:
	if textInputNode.text == str(self.exercise.answer):
		feedbackTextNode.text = "[center][color=dark_green]Correct! Well done!"
	else:
		if textInputNode.text.is_valid_int():
			feedbackTextNode.text = "[center][color=red]That's not quite right. Keep trying!"
		else:
			feedbackTextNode.text = "[center][color=red]Please enter an integer"

func text_changed() -> void:
	if "\n" in textInputNode.text:
		textInputNode.text = textInputNode.text.replace("\n", "")
		check()
	elif feedbackTextNode.text != "":
		feedbackTextNode.text = ""
