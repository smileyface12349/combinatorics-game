extends Node

var dialogueResource: DialogueResource = preload("res://Dialogue/intro.dialogue")
var chooseTopicScene: PackedScene = preload("res://ChooseTopic/choose_topic.tscn")
var track: AudioStream = preload("res://Music/Morning.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.show_dialogue_balloon(dialogueResource)
	DialogueManager.dialogue_ended.connect(dialogue_ended)
	MusicPlayer.change_track(track)

func dialogue_ended(resource: DialogueResource) -> void:
	SaveData.seen_dialogue.append("intro")
	SaveData.write()
	get_tree().change_scene_to_packed(chooseTopicScene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
