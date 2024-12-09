extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("pressed", go)

func go() -> void:
	get_tree().change_scene_to_file("res://Planarity/planarity_level.tscn")
