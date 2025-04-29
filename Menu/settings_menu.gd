extends Node

@export var doneButton: Button
@export var musicVolume: SBSliderButton
@export var effectsVolume: SBSliderButton
@export var bijectionsMenu: SBSpinButton
@export var fullscreenButton: SBSpinButton
@export var showIntroButton: Button
@export var resetDialogueButton: Button
@export var resetConfirmButton: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	doneButton.connect("pressed", go_to_menu)
	musicVolume.value = SaveData.music_volume
	effectsVolume.value = SaveData.effects_volume
	if SaveData.boring_bijections:
		bijectionsMenu.selected = 1
	else:
		bijectionsMenu.selected = 0
	if SaveData.fullscreen:
		fullscreenButton.selected = 1
	else:
		fullscreenButton.selected = 0
	showIntroButton.pressed.connect(show_intro)
	fullscreenButton.item_selected.connect(fullscreen_changed)
	resetDialogueButton.pressed.connect(reset_dialogue)
	resetConfirmButton.pressed.connect(reset_confirm)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		go_to_menu()

	SaveData.music_volume = int(musicVolume.value)
	SaveData.effects_volume = int(effectsVolume.value)
	if bijectionsMenu.selected == 0:
		SaveData.boring_bijections = false
	elif bijectionsMenu.selected == 1:
		SaveData.boring_bijections = true

func go_to_menu() -> void:
	SaveData.write()
	get_tree().change_scene_to_file("res://Menu/menu.tscn")

func show_intro() -> void:
	SaveData.seen_dialogue.erase("intro")
	SaveData.write()

func fullscreen_changed(selected: int) -> void:
	if selected == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif selected == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	SaveData.fullscreen = selected == 1
	SaveData.write()

func reset_confirm() -> void:
	SaveData.seen_dialogue = []
	SaveData.write()

func reset_dialogue() -> void:
	resetConfirmButton.show()
	resetDialogueButton.hide()