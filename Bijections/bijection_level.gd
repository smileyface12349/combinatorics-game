extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene = preload("res://Scenes/bijection_element.tscn")
	var instance = scene.instantiate()
	add_child(instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
