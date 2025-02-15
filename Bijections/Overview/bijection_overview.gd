extends Node
class_name BijectionOverviewNode

@export var text: RichTextLabel
@export var availableHintsText: RichTextLabel
@export var levelHintButton: Button

var request_level_hint: Callable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	levelHintButton.connect("pressed", request_level_hint)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

const definitions_title: String = "[font_size=48][b]Important Definitions[/b][/font_size]"
const hints_title: String = "[font_size=48][b]Hints, Checks & Super Checks[/b][/font_size]"

func set_definitions_text(new_definitions_text: String) -> void:
	# Find out where the hints begin
	var text_parts: PackedStringArray = text.text.split(hints_title)
	
	# Update the first part
	text_parts[0] = definitions_title + "\n\n" + new_definitions_text
	
	# Join it back together and update
	text.text = text_parts[0] + hints_title + text_parts[1]
	

# Sets the definitions to display. Overrides any previously set.
func set_definitions(definitions: Array[BijectionDefinition]) -> void:
	var def_text: String = ""
	if definitions.is_empty():
		def_text = "This level does not have any particular definitions to be aware of\n\n"
	else:
		for definition: BijectionDefinition in definitions:
			def_text += definition._to_string() + "\n\n"
	set_definitions_text(def_text)

func set_hints_text(new_hints_text: String) -> void:
	# Find out where the hints begin
	var text_parts: PackedStringArray = text.text.split(hints_title)
	
	# Update the second part
	text_parts[1] = new_hints_text
	
	# Join it back together and update
	text.text = text_parts[0] + hints_title + text_parts[1]

# Sets the hints to display. Overrides any previous ones.
func set_hints(hints: Array[String]) -> void:
	var hints_text: String = ""
	if hints.is_empty():
		hints_text = "No hints used. Spend 🧠 and what you learn will appear here."
	else:
		for hint: String in hints:
			hints_text += "\n\n" + hint
	set_hints_text(hints_text)

# Updates the visual display of how many hints are left to the user
func set_available_hints(available_hints: int)  -> void:
	availableHintsText.text = "\n"
	for x: int in range(available_hints):
		availableHintsText.text += "🧠"
	for x: int in range(5-available_hints):
		availableHintsText.text += "💀"
	
# Hides the level hint button. Should be done when the hint is used, or there isn't a hint for this level
func hide_hint_button() -> void:
	levelHintButton.hide()
