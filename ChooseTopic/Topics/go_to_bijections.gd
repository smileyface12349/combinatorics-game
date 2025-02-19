extends Area2D

var topic_name: String = "Bijections"
var bijectionsScene: PackedScene = preload("res://Bijections/LevelSelect/lake_level_select.tscn")

func go() -> void:
	get_tree().change_scene_to_packed(bijectionsScene)
