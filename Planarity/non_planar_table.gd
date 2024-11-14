class_name NonPlanarTable
extends Control

@export var edgeCount: RichTextLabel
@export var vertexCount: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update(new_edge_count: int, new_vertex_count: int) -> void:
	edgeCount.text = str(new_edge_count)
	vertexCount.text = str(new_vertex_count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
