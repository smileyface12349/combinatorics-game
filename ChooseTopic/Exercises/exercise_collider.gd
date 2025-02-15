extends Area2D
class_name ExerciseCollider

var topic_name: String = "Bonus Exercise"

@export var id: int # A numeric ID to identify each problem. These are done consecutively starting at 1, with easier problems being first.
@export var title: String # A title. The problem description must make sense without the title.
@export var description: String # The full description of the problem.
@export var definitions: Array[String] # Any relevant definitions that the player might not know.
@export var answer: int # The correct answer to the problem

@export var exerciseLayer: CanvasLayer

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
	instance.set_exercise(self, func() -> void:
		instance.queue_free()
	)
	exerciseLayer.add_child(instance)
