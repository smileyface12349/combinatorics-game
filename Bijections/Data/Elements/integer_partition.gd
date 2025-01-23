extends BijectionElement
class_name IntegerPartitionElement

var parts: Array[int]

func _init(text: String, parts: Array[int], id: int) -> void:
	super(text, id)
	self.parts = parts
