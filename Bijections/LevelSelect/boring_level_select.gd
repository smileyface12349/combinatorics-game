extends Node

@export var level0: Button
@export var level1: Button
@export var level2: Button
@export var level3: Button
@export var level4: Button
@export var level5: Button
@export var backButton: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level0.connect("pressed", goto_0)
	level1.connect("pressed", goto_1)
	level2.connect("pressed", goto_2)
	level3.connect("pressed", goto_3)
	level4.connect("pressed", goto_4)
	level5.connect("pressed", goto_5)
	backButton.connect("pressed", goto_back)
	MusicPlayer.change_track(preload("res://Music/Salty Ditty.mp3"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func goto_0() -> void:
	BijectionSettings.current_level = BijectionLevel0.new()
	get_tree().change_scene_to_file("res://Bijections/bijection_level.tscn")

func goto_1() -> void:
	BijectionSettings.current_level = BijectionLevel1.new()
	get_tree().change_scene_to_file("res://Bijections/bijection_level.tscn")

func goto_2() -> void:
	BijectionSettings.current_level = BijectionLevel2.new()
	get_tree().change_scene_to_file("res://Bijections/bijection_level.tscn")

func goto_3() -> void:
	BijectionSettings.current_level = BijectionLevel3.new()
	get_tree().change_scene_to_file("res://Bijections/bijection_level.tscn")

func goto_4() -> void:
	BijectionSettings.current_level = BijectionLevel4.new()
	get_tree().change_scene_to_file("res://Bijections/bijection_level.tscn")

func goto_5() -> void:
	BijectionSettings.current_level = BijectionLevel5.new()
	get_tree().change_scene_to_file("res://Bijections/bijection_level.tscn")

func goto_back() -> void:
	get_tree().change_scene_to_file("res://ChooseTopic/BoringMenu/boring_menu.tscn")