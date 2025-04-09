extends DyckPathElement
class_name MotzkinPathElement

# steps: 0 = horizontal step, 1 = up step, -1 = down step
# colours: 0 = black, 1 = red, 2 = blue
var colours: Array[int] = []

func _init(steps: Array[int], colours: Array[int], id: int) -> void:
    super(steps, id)
    self.colours = colours
    assert(len(steps) == len(colours))
    
    # Obtain a string representation (not currently used when diagrams are disabled)
    var text: String = ""
    for i: int in range(len(steps)):
        # Start colour
        if colours[i] == 1:
            text += "[color=red]"
        elif colours[i] == 2:
            text += "[color=blue]"
        # Text
        if steps[i] == 0:
            text += "_"
        elif steps[i] > 0:
            text += "U"
        elif steps[i] < 0:
            text += "D"
        # End colour
        if colours[i] > 0:
            text += "[/color]"


func get_code_representation() -> Variant:
    var steps: Array[int] = []
    for i: int in range(len(self.steps)):
        steps.append(self.steps[i] + self.colours[i] * 10)
    return steps

func get_colour(i: int) -> Color:
    if colours[i] == 0:
        return Color.BLACK
    elif colours[i] == 1:
        return Color.RED
    elif colours[i] == 2:
        return Color.BLUE
    else:
        return Color.PURPLE