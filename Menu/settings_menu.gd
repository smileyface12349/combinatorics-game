extends Node

@export var doneButton: Button
@export var musicVolume: SBSliderButton
@export var effectsVolume: SBSliderButton
@export var showIntroButton: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	doneButton.connect("pressed", go_to_menu)
	musicVolume.value = SaveData.music_volume
	effectsVolume.value = SaveData.effects_volume
	showIntroButton.pressed.connect(show_intro)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		go_to_menu()

	SaveData.music_volume = int(musicVolume.value)
	SaveData.effects_volume = int(effectsVolume.value)

func go_to_menu() -> void:
	SaveData.write()
	get_tree().change_scene_to_file("res://Menu/menu.tscn")

func show_intro() -> void:
	SaveData.seen_dialogue.erase("intro")
	SaveData.write()