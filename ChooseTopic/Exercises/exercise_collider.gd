extends Area2D
class_name ExerciseCollider

var topic_name: String = "Bonus Exercise"

var id: int # A numeric ID to identify each problem. These are done consecutively starting at 1, with easier problems being first.
var title: String # A title. The problem description must make sense without the title.
var description: String # The full description of the problem.
var definitions: Array[String] # Any relevant definitions that the player might not know.
var answer: int # The correct answer to the problem

var exercise_screen: PackedScene = preload("res://ChooseTopic/Exercises/exercise_screen.tscn")

func _init(id: int, title: String, description: String, definitions: Array[String], answer: int) -> void:
    self.id = id
    self.topic_name = "Bonus Exercise " + str(id)
    self.title = title
    self.description = description
    self.definitions = definitions
    self.answer = answer

func go() -> void:
    # TODO: Add exercise to global variable
    await get_tree().change_scene_to_packed(exercise_screen)