extends Node
class_name BijectionDefinition

var title: String
var description: String
var example: String
var non_example: String

## title - The term that is being defined. This should still be included in the description such that
##   the definition may be displayed without the description and it still make sense.
## description - The actual definition
## example - An optional example of something that satisfies this condition
## non_example - An optional example of something that doesn't, but may be confused to be this thing
func _init(title: String, description: String, example: String = "", non_example: String = "") -> void:
	self.title = title
	self.description = description
	self.example = example
	self.non_example = non_example
