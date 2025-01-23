class_name BijectionLevel

var bijections: Dictionary # {problem_size: bijection}
var left_text: String
var right_text: String
var left_title: String
var right_title: String
var hint: String
var proof: BijectionProof

func _init(left_title: String, right_title: String, left_description: String, right_description: String, bijections: Dictionary, hint: String = "", proof: BijectionProof = BijectionProof.new()) -> void:
	self.left_title = left_title
	self.left_text = left_description
	self.right_title = right_title
	self.right_text = right_description
	self.bijections = bijections
	self.hint = hint
	self.proof = proof
