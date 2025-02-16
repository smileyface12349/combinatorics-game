extends Area2D

var topic_name: String = "Catalan Number Zone"

func go() -> void:
	get_tree().change_scene_to_file("res://Bijections/Catalan/catalan_menu.tscn")
