extends Area2D
class_name ExerciseCollider

var topic_name: String = "Bonus Exercise"

@export var parent: Exercise

var exercise_screen: PackedScene = preload("res://ChooseTopic/Exercises/exercise_screen.tscn")

#func _init(id: int, title: String, description: String, definitions: Array[String], answer: int) -> void:
	#self.id = id
	#self.topic_name = "Bonus Exercise " + str(id)
	#self.title = title
	#self.description = description
	#self.definitions = definitions
	#self.answer = answer

func go() -> void:
	var instance: ExerciseController = exercise_screen.instantiate()
	instance.set_exercise(parent, func() -> void:
		instance.queue_free()
		GeneralSettings.is_popup_open = false
	)
	GeneralSettings.is_popup_open = true
	parent.exerciseLayer.add_child(instance)
