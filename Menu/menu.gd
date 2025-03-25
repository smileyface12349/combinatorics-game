extends Node

@export var playButton: Button
@export var settingsButton: Button
@export var quitButton: Button

var chooseTopicScene: PackedScene = preload("res://ChooseTopic/choose_topic.tscn")
var settingsScene: PackedScene = preload("res://Menu/settings.tscn")
var track: AudioStream = preload("res://Music/Digital Lemonade.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playButton.pressed.connect(on_play)
	settingsButton.pressed.connect(on_settings)
	quitButton.pressed.connect(on_quit)
	MusicPlayer.change_track(track)
	SaveData.read()

	# Test code
	Parser.parse("if when")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		on_quit()

func on_play() -> void:
	if "intro" in SaveData.seen_dialogue:
		get_tree().change_scene_to_packed(chooseTopicScene)
	else:
		get_tree().change_scene_to_file("res://Menu/intro.tscn")
	
func on_settings() -> void:
	get_tree().change_scene_to_packed(settingsScene)
	
func on_quit() -> void:
	get_tree().quit()
