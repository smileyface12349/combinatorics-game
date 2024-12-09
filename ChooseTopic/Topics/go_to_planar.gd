extends Node

var topic_name: String = "Planar Graphs"

func go() -> void:
	get_tree().change_scene_to_file("res://Planarity/planar_settings.tscn")
