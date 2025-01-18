extends Node
class_name BijectionLevelNode

@export var matchElements: MatchElements
@export var leftTitle: RichTextLabel
@export var leftDescription: RichTextLabel
@export var rightTitle: RichTextLabel
@export var rightDescription: RichTextLabel
@export var problemSizeIndicator: RichTextLabel
@export var panel: Panel

# This script exists to pass data straight through from the root node of a bijection to the
# subcomponents that need it

## Setup everything that's specific to this particular problem size (value of n)
func set_bijection(bijection: Bijection) -> void:
	matchElements.set_bijection(bijection)
	problemSizeIndicator.text = "n = " + str(bijection.problem_size)
	panel.size.y = 550 + bijection.from.size() * 132

## Setup everything that's specific to this level in general
func set_level(level: BijectionLevel) -> void:
	leftTitle.text = "[center]" + level.left_title
	leftDescription.text = "[center]" + level.left_text
	rightTitle.text = "[center]" + level.right_title
	rightDescription.text = "[center]" + level.right_text
