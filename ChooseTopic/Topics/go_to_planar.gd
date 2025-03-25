extends Node

var topic_name: String = "Planar Graphs"

var dialogueResource: DialogueResource = preload("res://Dialogue/planar.dialogue")

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
		get_tree().change_scene_to_file("res://Planarity/planar_settings.tscn")
