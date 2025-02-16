extends Area2D

var topic_name: String = "Level"

@export var parent: Lilypad

func _ready() -> void:
	self.topic_name = "Level " + str(parent.id)

func go() -> void:
	# Buttons to change level
	# TODO: Store a map somewhere else
	if parent.id == 0:
		BijectionSettings.current_level = BijectionLevel0.new()
	elif parent.id == 1:
		BijectionSettings.current_level = BijectionLevel1.new()
	elif parent.id == 2:
		BijectionSettings.current_level = BijectionLevel2.new()
	elif parent.id == 4:
		BijectionSettings.current_level = BijectionLevel4.new()
	elif parent.id == 5:
		BijectionSettings.current_level = BijectionLevel5.new()
	
	# Test level
	elif parent.id == -1:
		BijectionSettings.current_level = BijectionLevelTest.new()

	print_debug("Going to level: " + str(parent.id))
	
	# If they chose a level
	if BijectionSettings.current_level != null:
		get_tree().change_scene_to_file("res://Bijections/bijection_level.tscn")
