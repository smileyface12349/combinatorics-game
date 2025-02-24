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
@export var hintsRemainingDisplay: RichTextLabel
@export var hintText: RichTextLabel
@export var hintNumberButton: Button
@export var hintWhichButton: Button
@export var previousButton: Button
@export var nextButton: Button

var showDiagrams: bool = true
var update_show_diagrams: Callable
var jump_to_previous: Callable
var jump_to_next: Callable
var bijection: Bijection
var add_hint: Callable
var available_hints: int

const vertical_spacing_between_elements: int = 32
const panel_size_excluding_elements: int = 650

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
	
# Function to call whenever the state changes of what's matched to what
func set_callback_on_match(callback: Callable) -> void:
	matchElements.callback_on_match = func() -> void:
		callback.call()
		hintText.text = ""
	
# Function to add a new hint with the text
func set_add_hint(add_hint: Callable) -> void:
	self.add_hint = add_hint

# Update camera control functions
func set_camera_controls(jump_to_previous: Callable, jump_to_next: Callable) -> void:
	self.jump_to_previous = jump_to_previous
	self.jump_to_next = jump_to_next

## When we toggle it, tell the other checkboxes to update and pass it through
func checkbox_toggled(toggled_on: bool) -> void:
	matchElements.set_show_diagrams(toggled_on)
	update_show_diagrams.call(toggled_on)
	set_panel_size()
	
## Checks if it's fully correct. Requires everything to be matched up.
func check() -> bool:
	return matchElements.check()
	
## Checks if everything has been matched up.
func is_complete() -> bool:
	return matchElements.is_complete()
	
## Updates the appearance to show it as done (after double checking that it is actually done)
func mark_as_done() -> void:
	matchElements.mark_as_done()
	
## Updates the appearance to suggest it's incorrect
func show_incorrect(incorrect: bool = true) -> void:
	matchElements.show_incorrect(incorrect)
	
# Receiving updates when hints are spent
func set_hints_available(hints_available: int) -> void:
	self.available_hints = hints_available
	hintsRemainingDisplay.text = "[center]Hints: (" + str(available_hints) + " remaining):"

# Hint: How many are correct?
func use_hint_number() -> void:
	if available_hints >= 1:
		# Generate text for the hints log
		var num_correct: int = matchElements.get_number_correct()
		var extended_text: String = "[u]Check[/u]: You used a check on n=" + str(bijection.problem_size) + ":"
		var total: int = 0
		for e: BijectionElement in matchElements.bijection.from:
			if e.match != null:
				extended_text += "\n - " + e.text + " was matched with " + e.match.text
				total += 1
		extended_text += "\nand learned that " + str(num_correct) + "/" + str(total) + " are matched correctly"

		if total == 0:
			# If they haven't actually matched anything, abandon ship and don't spend the user's hints
			hintText.text = "[center]You haven't matched anything yet!"
		elif matchElements.bijection.from.size() <= 1:
			hintText.text = "[center]Don't waste your hints! You know this one is correct already!"
		elif hintText.text != "":
			hintText.text = "[center]Change the matching before getting a new hint"
		else:
			if num_correct == total:
				hintText.text = "[center]All correct! You can find this later in Hints & Definitions"
				# display them as correct
				for e: BijectionElement in matchElements.bijection.from:
					if e.match != null:
						matchElements.display_correct.append(e.id)
				matchElements.queue_redraw()
			else:
				hintText.text = "[center]" + str(num_correct) + "/" + str(total) + " correct! You can find this later in Hints & Definitions"
			add_hint.call(1, extended_text)
	else:
		hintText.text = "[center]You've used all of your hints"

# Hint: Which ones are correct?
func use_hint_which() -> void:
	if available_hints >= 2:
		# Work out which ones are correct and display this
		matchElements.check_individually()
		# Generate a text form for the hints log
		var extended_text: String = "[u]Super Check[/u]: You used a super check on n=" + str(bijection.problem_size) + ":"
		var total: int = 0
		var correct: int = 0
		for e: BijectionElement in matchElements.bijection.from:
			if e.match == null:
				extended_text += "\n - " + e.text + " was unmatched ❌"
			else:
				total += 1
				extended_text += "\n - " + e.text + " was matched with " + e.match.text
				if e.id == e.match.id:
					extended_text += " ✅"
					correct += 1
				else:
					extended_text += " ❌"
		
		if total == 0:
			hintText.text = "[center]You haven't matched anything yet!"
		elif matchElements.bijection.from.size() <= 1:
			hintText.text = "[center]Don't waste your hints! You know this one is correct already!"
		elif hintText.text != "":
			hintText.text = "[center]Change the matching before getting a new hint"
		else:
			if correct == total:
				hintText.text = "[center]All correct! You can find this later in Hints & Definitions"
			else:
				hintText.text = str(correct) + "/" + str(total) + " correct! You can find this later in Hints & Definitions"
			add_hint.call(2, extended_text)
		
	else:
		if available_hints == 0:
			hintText.text = "[center]You've used all of your hints"
		else:
			hintText.text = "[center]You only have " + str(available_hints) + "/2 hints"

# Connect up buttons
func _ready() -> void:
	showDiagramsCheckbox.connect("toggled", checkbox_toggled)
	hintNumberButton.connect("pressed", use_hint_number)
	hintWhichButton.connect("pressed", use_hint_which)
	previousButton.connect("pressed", jump_to_previous)
	nextButton.connect("pressed", jump_to_next)
