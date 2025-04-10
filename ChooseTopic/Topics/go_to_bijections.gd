extends Area2D

var topic_name: String = "Bijections"
var bijectionsScene: PackedScene = preload("res://Bijections/LevelSelect/lake_level_select.tscn")


var dialogueResource: DialogueResource = preload("res://Dialogue/bijections.dialogue")

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(dialogue_ended)

func go() -> void:
	GeneralSettings.is_popup_open = true
	DialogueManager.show_dialogue_balloon(dialogueResource)

func dialogue_ended(resource: DialogueResource) -> void:
	GeneralSettings.is_popup_open = false
	if resource != dialogueResource:
		return
	if GeneralSettings.dialogue_result == 1:
		if SaveData.boring_bijections:
			get_tree().change_scene_to_file("res://Bijections/LevelSelect/boring_level_select.tscn")
		else:
			get_tree().change_scene_to_packed(bijectionsScene)
