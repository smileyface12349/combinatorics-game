extends Node
class_name ExerciseController

@export var menuButton: Button
@export var titleNode: RichTextLabel
@export var descriptionNode: RichTextLabel
@export var definitionsNode: RichTextLabel
@export var textInputNode: TextEdit
@export var checkButtonNode: Button
@export var feedbackTextNode: RichTextLabel

var exercise: ExerciseCollider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_exercise(exercise: ExerciseCollider, on_close: Callable) -> void:
	self.exercise = exercise
	menuButton.connect("pressed", on_close)
	titleNode.text = "[center]Exercise " + str(exercise.id)
	descriptionNode.text = exercise.description
	if exercise.definitions.is_empty():
		definitionsNode.text = "No definitions"
	else:
		definitionsNode.text = "\n".join(exercise.definitions)
	feedbackTextNode.text = ""
