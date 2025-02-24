extends Node

@export var houseButton: Button
@export var planarButton: Button
@export var bijectionsButton: Button
@export var catalanButton: Button
@export var colouringsButton: Button

var chooseTopicScene: PackedScene = preload("res://ChooseTopic/choose_topic.tscn")
var bijectionsScene: PackedScene = preload("res://Bijections/LevelSelect/lake_level_select.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	houseButton.connect("pressed", go_to_house)
	planarButton.connect("pressed", go_to_planar)
	bijectionsButton.connect("pressed", go_to_bijections)
	catalanButton.connect("pressed", go_to_catalan)
	colouringsButton.connect("pressed", go_to_colourings)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func go_to_house() -> void:
	get_tree().change_scene_to_packed(chooseTopicScene)

func go_to_planar() -> void:
	get_tree().change_scene_to_file("res://Planarity/planar_settings.tscn")

func go_to_bijections() -> void:
	get_tree().change_scene_to_packed(bijectionsScene)

func go_to_catalan() -> void:
	get_tree().change_scene_to_file("res://Bijections/Catalan/catalan_menu.tscn")

func go_to_colourings() -> void:
	get_tree().change_scene_to_file("res://Colouring/colouring_settings.tscn")