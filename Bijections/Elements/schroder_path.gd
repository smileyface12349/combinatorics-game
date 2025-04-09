extends DyckPathElement
class_name SchroderPathElement

# steps: 0 = horizontal step, 1 = up step, -1 = down step
# (horizontal steps have length 2)
var schroder_steps: Array[int] = []

func _init(schroder_steps: Array[int], id: int) -> void:
    var steps: Array[int] = []
    for step: int in schroder_steps:
        if step == 0:
            steps.append(0)
            steps.append(0)
        else:
            steps.append(step)
    super(steps, id)
    self.schroder_steps = schroder_steps

func get_code_representation() -> Variant:
    return schroder_steps
