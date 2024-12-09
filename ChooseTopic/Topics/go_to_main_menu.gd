extends Area2D

var topic_name: String = "Main Menu"

func go() -> void:
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
