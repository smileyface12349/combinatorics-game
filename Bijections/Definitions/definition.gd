extends Node
class_name BijectionDefinition

var title: String
var description: String

## title - The term that is being defined. This should still be included in the description such that
##   the definition may be displayed without the description and it still make sense.
## description - The actual definition
func _init(title: String, description: String) -> void:
	self.title = title
	self.description = description
