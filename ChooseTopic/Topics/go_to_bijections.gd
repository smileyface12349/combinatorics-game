extends Area2D

var topic_name: String = "Bijections"

func go() -> void:
	get_tree().change_scene_to_file("res://Bijections/bijection_level.tscn")