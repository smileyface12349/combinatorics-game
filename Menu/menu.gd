extends Node

@export var playButton: Button
@export var settingsButton: Button
@export var quitButton: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playButton.pressed.connect(on_play)
	settingsButton.pressed.connect(on_settings)
	quitButton.pressed.connect(on_quit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_play() -> void:
	get_tree().change_scene_to_file("res://ChooseTopic/choose_topic.tscn")
	
func on_settings() -> void:
	pass
	
func on_quit() -> void:
	get_tree().quit()
