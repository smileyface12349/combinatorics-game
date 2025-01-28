extends Node
class_name BijectionLevelNode

@export var matchElements: MatchElements
@export var leftTitle: RichTextLabel
@export var leftDescription: RichTextLabel
@export var rightTitle: RichTextLabel
@export var rightDescription: RichTextLabel
@export var problemSizeIndicator: RichTextLabel
@export var panel: Panel
@export var showDiagramsCheckbox: CheckButton

var showDiagrams: bool = true
var update_show_diagrams: Callable

# This script exists to pass data straight through from the root node of a bijection to the
# subcomponents that need it

## Setup everything that's specific to this particular problem size (value of n)
func set_bijection(bijection: Bijection) -> void:
	matchElements.set_bijection(bijection)
	problemSizeIndicator.text = "n = " + str(bijection.problem_size)
	panel.size.y = 550 + bijection.from.size() * 132

## Setup everything that's specific to this level in general
func set_level(level: BijectionLevel, update_show_diagrams: Callable) -> void:
	leftTitle.text = "[center]" + level.left_title
	leftDescription.text = "[center]" + level.left_text
	rightTitle.text = "[center]" + level.right_title
	rightDescription.text = "[center]" + level.right_text
	self.update_show_diagrams = update_show_diagrams

## Pass show diagrams straight through
func set_show_diagrams(value: bool) -> void:
	matchElements.set_show_diagrams(value)
	showDiagramsCheckbox.button_pressed = value
	
func checkbox_toggled(toggled_on: bool) -> void:
	matchElements.set_show_diagrams(toggled_on)
	update_show_diagrams.call(toggled_on)
	
func _ready() -> void:
	showDiagramsCheckbox.connect("toggled", checkbox_toggled)
