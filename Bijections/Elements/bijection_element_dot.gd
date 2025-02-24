extends Node2D
class_name BijectionElementDot

const circle_radius: float = 10
const hitbox_radius: float = 40

func _draw() -> void:
	# Draw dot
	draw_circle(Vector2(0, 0), circle_radius, Color.BLACK)
