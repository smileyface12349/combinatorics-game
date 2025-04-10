extends Node

@export var topic: String
@export var finished_hut: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if SaveData.topics_done.has(topic):
		# This topic has been completed, so we can show the hut
		finished_hut.show()
	else:
		# This topic has not been completed, so we hide the hut
		finished_hut.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
