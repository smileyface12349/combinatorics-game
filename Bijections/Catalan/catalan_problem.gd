extends Node
class_name CatalanProblem

var description: String
var title: String
var id: int
var bijections: Dictionary # {id: proof}
var definitions: Array[BijectionDefinition]

func _init(title: String, description: String, id: int, 
		bijections: Dictionary = {}, definitions: Array[BijectionDefinition] = []) -> void:
    self.title = title
    self.description = description
    self.id = id
    self.bijections = bijections
    self.definitions = definitions

func get_sizes_dict() -> Dictionary:
    # Overridden in superclasses
    return {}

func generate_elements(size: int) -> Array[BijectionElement]:
    # Overridden in superclasses
    return []

func generate_elements_code(size: int) -> Array:
    var elements: Array = []
    for e: BijectionElement in generate_elements(size):
        elements.append(e.get_code_representation())
    return elements
