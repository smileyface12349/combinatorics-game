extends Node

const bijection_width: int = 1500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_level(BijectionLevel0.new()) # TODO: Temp

## Creates the elements to represent the level
func create_level(level: BijectionLevel) -> void:
	for problem_size: int in level.bijections:
		print_debug(level.bijections[problem_size])
		create_bijection_n(level.bijections[problem_size], level)

## Create the elements to represent a bijection of particular size n
func create_bijection_n(bijection: Bijection, level: BijectionLevel) -> void:
	var scene: PackedScene = preload("res://Bijections/bijection_n.tscn")
	var instance: BijectionLevelNode = scene.instantiate()
	print_debug("Setting bijection...")
	instance.set_bijection(bijection)
	instance.set_level(level)
	instance.position.x = bijection.problem_size * bijection_width + 1000
	add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# TODO: Move stuff out of match.gd
