extends Node

var topic_name: String = "Graph Colourings"

func go() -> void:
	get_tree().change_scene_to_file("res://Colouring/colouring_settings.tscn")
