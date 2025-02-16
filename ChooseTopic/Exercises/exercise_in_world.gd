extends Node
class_name Exercise

@export var id: int # A numeric ID to identify each problem. These are done consecutively starting at 1, with easier problems being first.
@export var title: String # A title. The problem description must make sense without the title.
@export_multiline var description: String # The full description of the problem.
@export var definitions: Array[String] # Any relevant definitions that the player might not know.
@export var answer: int # The correct answer to the problem

@export var exerciseLayer: CanvasLayer
@export var numberDisplay: RichTextLabel

# func _init(id: int, title: String, description: String, definitions: Array[String], answer: int) -> void:
# 	self.id = id
# 	self.title = title
# 	self.description = description
# 	self.definitions = definitions
# 	self.answer = answer

func _ready() -> void:
	numberDisplay.text = "[center]" + str(id)
