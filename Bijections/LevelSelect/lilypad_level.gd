extends Node
class_name Lilypad

# Controllable parameters
@export var id: int

# Internal references
@export var collider: Area2D
@export var numberText: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	numberText.text = "[center]" + str(id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
