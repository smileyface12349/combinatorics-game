extends Node

@export var boringMenuButton: Button

var bijectionsScene: PackedScene = preload("res://Bijections/LevelSelect/lake_level_select.tscn")
var track: AudioStream = preload("res://Music/Balloon Game.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boringMenuButton.connect("pressed", go_to_boring)
	MusicPlayer.change_track(track)

func _input(event: InputEvent) -> void:
	if GeneralSettings.is_popup_open:
		return
		
	# ESC to go back to menu
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Menu/menu.tscn")
	
	# Buttons to change level (in case the user doesn't want to, or can't, drive around)
	# if Input.is_action_just_pressed("num_0"):
	# 	# 0 = bijections
	# 	get_tree().change_scene_to_packed(bijectionsScene)
	# elif Input.is_action_just_pressed("num_1"):
	# 	# 1 = catalan numbers
	# 	get_tree().change_scene_to_file("res://Bijections/Catalan/catalan_menu.tscn")
	# elif Input.is_action_just_pressed("num_2"):
	# 	# 2 = planar graphs
	# 	get_tree().change_scene_to_file("res://Planarity/planar_settings.tscn")
	# elif Input.is_action_just_pressed("num_3"):
	# 	# 3 = graph colouring
	# 	get_tree().change_scene_to_file("res://Colouring/colouring_settings.tscn")
	
	# Shortcut buttons
	if Input.is_action_just_pressed("num_1"):
		if SaveData.boring_bijections:
			get_tree().change_scene_to_file("res://Bijections/LevelSelect/boring_level_select.tscn")
		else:
			get_tree().change_scene_to_packed(bijectionsScene)
	elif Input.is_action_just_pressed("num_2"):
		get_tree().change_scene_to_file("res://Bijections/Catalan/catalan_menu.tscn")
	elif Input.is_action_just_pressed("num_3"):
		get_tree().change_scene_to_file("res://Planarity/planarity_level.tscn")
	elif Input.is_action_just_pressed("num_4"):
		get_tree().change_scene_to_file("res://Colouring/colouring_level.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func go_to_boring() -> void:
	get_tree().change_scene_to_file("res://ChooseTopic/BoringMenu/boring_menu.tscn")
