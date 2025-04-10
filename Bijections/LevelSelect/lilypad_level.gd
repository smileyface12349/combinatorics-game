extends Node
class_name Lilypad

# Controllable parameters
@export var id: int

# Internal references
@export var collider: Area2D
@export var numberText: RichTextLabel
@export var lilypadIncomplete: Node2D
@export var lilypadComplete: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	numberText.text = "[center]" + str(id)
	if id in SaveData.bijection_levels_done:
		lilypadIncomplete.hide()
		lilypadComplete.show()
	else:
		lilypadIncomplete.show()
		lilypadComplete.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
