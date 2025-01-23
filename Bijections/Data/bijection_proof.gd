extends Node
class_name BijectionProof

var text: String
var difficulty: int

# Proof Difficulty Guidance
# 0 = Trivial proof. Contains no mathematical reasoning whatsoever. E.g. AB <-> 12
# 1 = Simple. Limited thinking required. E.g. Dyck paths vs balanced parentheses
# 2-3 = Average. At least one jump in reasoning required. E.g. stars and bars
# 4-5 = Tricky. A difficult jump in reasoning, or multiple jumps. E.g. most integer partition questions
# 6+ = Very difficult. Do not be afraid to use high numbers for problems requiring novel insights.
# Note that the triangle inequality is assumed to hold, as proofs may be done transitively 'through'
# other problems. A direct proof should never be  more difficult than an indirect proof.
# While this guidance is a first step, problems should primarily be scored against each other.

func _init(text: String = "", difficulty: int = -1) -> void:
	self.text = text
	self.difficulty = -1

func display() -> String:
	if text == "":
		return "No proof available"
	else:
		return text
