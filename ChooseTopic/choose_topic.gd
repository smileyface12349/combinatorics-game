extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if GeneralSettings.is_popup_open:
		return
		
	# ESC to go back to menu
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Menu/menu.tscn")
	
	# Buttons to change level (in case the user doesn't want to, or can't, drive around)
	if Input.is_action_just_pressed("num_0"):
		# 0 = bijections
		get_tree().change_scene_to_file("res://Bijections/bijection_level_select.tscn")
	elif Input.is_action_just_pressed("num_1"):
		# 1 = catalan numbers
		pass
	elif Input.is_action_just_pressed("num_2"):
		# 2 = planar graphs
		get_tree().change_scene_to_file("res://Planarity/planar_settings.tscn")
	
	# If they chose a level
	if BijectionSettings.current_level != null:
		get_tree().change_scene_to_file("res://Bijections/bijection_level.tscn")
	# TODO: Why is this here?

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
