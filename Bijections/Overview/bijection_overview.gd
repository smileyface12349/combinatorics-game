extends Node
class_name BijectionOverviewNode

@export var text: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

const definitions_title: String = "[font_size=48][b]Important Definitions[/b][/font_size]"
const hints_title: String = "[font_size=48][b]Hints[/b][/font_size]"

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
