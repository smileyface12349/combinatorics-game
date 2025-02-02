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
var bijection: Bijection

const vertical_spacing_between_elements: int = 32
const panel_size_excluding_elements: int = 550

# This script exists to pass data straight through from the root node of a bijection to the
# subcomponents that need it

## Setup everything that's specific to this particular problem size (value of n)
func set_bijection(bijection: Bijection) -> void:
	matchElements.set_bijection(bijection)
	problemSizeIndicator.text = "n = " + str(bijection.problem_size)
	self.bijection = bijection
	# This doesn't use set_panel_size() because the sizes aren't ready yet
	panel.size.y = panel_size_excluding_elements + bijection.from.size() * (100 + vertical_spacing_between_elements)

## Setup everything that's specific to this level in general
func set_level(level: BijectionLevel, update_show_diagrams: Callable) -> void:
	leftTitle.text = "[center]" + level.left_title
	leftDescription.text = "[center]" + level.left_text
	rightTitle.text = "[center]" + level.right_title
	rightDescription.text = "[center]" + level.right_text
	self.update_show_diagrams = update_show_diagrams

## Sets the panel to the appropriate size. This must be done when elements change size. It is safe
## to call even when the size of elements does not change.
## Be careful when calling this before the elements have had their sizes set up
func set_panel_size() -> void:
	if bijection.from.is_empty():
		# Special case to prevent error when trying to access element size
		panel.size.y = panel_size_excluding_elements
	else:
		panel.size.y = panel_size_excluding_elements + bijection.from.size() * (bijection.from[0].size.y + 32)
		
## If one of the other toggles does it, then update our own checkbox and pass it through
func set_show_diagrams(value: bool) -> void:
	matchElements.set_show_diagrams(value)
	showDiagramsCheckbox.button_pressed = value
	set_panel_size()
	
## When we toggle it, tell the other checkboxes to update and pass it through
func checkbox_toggled(toggled_on: bool) -> void:
	matchElements.set_show_diagrams(toggled_on)
	update_show_diagrams.call(toggled_on)
	set_panel_size()
	
func _ready() -> void:
	showDiagramsCheckbox.connect("toggled", checkbox_toggled)
