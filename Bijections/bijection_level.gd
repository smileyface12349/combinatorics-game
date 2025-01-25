extends Node

const bijection_width: int = 1500
var bijection_n: PackedScene = preload("res://Bijections/bijection_n.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_level(BijectionSettings.current_level) 
	
## Creates the elements to represent the level
func create_level(level: BijectionLevel) -> void:
	var position: Vector2 = Vector2(1000, 500)
	for problem_size: int in level.bijections:
		create_bijection_n(level.bijections[problem_size], level, position)
		position.x += bijection_width

## Create the elements to represent a bijection of particular size n
func create_bijection_n(bijection: Bijection, level: BijectionLevel, position: Vector2) -> void:
	var instance: BijectionLevelNode = bijection_n.instantiate()
	instance.set_bijection(bijection)
	instance.set_level(level)
	instance.position = position
	add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Navigation back
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		BijectionSettings.current_level = null
		get_tree().change_scene_to_file("res://Bijections/bijection_level_select.tscn")
