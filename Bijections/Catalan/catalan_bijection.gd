extends Node
class_name CatalanBijection

var bijection: String
var proof: String
var mapping: Callable
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

func _init(bijection: String, mapping: Callable, proof: String = "No proof available", difficulty: int = -1) -> void:
    self.bijection = bijection
    self.mapping = mapping
    self.proof = proof
    self.difficulty = -1

func to_proof() -> BijectionProof:
    return BijectionProof.new("Bijection: " + bijection + "\n\nProof: " + proof, difficulty)
