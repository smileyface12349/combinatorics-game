extends BijectionElement
class_name HouseOfCardsElement

# Each element is an array containing that level, 1 = spot is filled, 0 = it isn't
# First element should be all 1s, then successive layers should only have a 1 above 2 neighbouring 1s
# Each successive layer should have length 1 less than the previous.
var levels: Array[Array] = []

func _init(levels: Array[Array], id: int) -> void:
    self.levels = levels
    
    # TODO: Obtain a string representation (not currently used when diagrams are disabled)
    var text: String = "TODO"
    
    # Initialise super
    super(text, id)

# No text representation for this
func draw_contents_text() -> void:
    draw_contents_diagrams()

func get_code_representation() -> Variant:
    return self.levels

# Get the height of the highest peak
func get_max_height() -> int:
    var max_height: int = 0
    for level: Array in self.levels:
        if 1 in level:
            max_height += 1
        else:
            break
    return max_height
    
# Get the width
func get_width() -> int:
    return len(self.levels[0])

# Constants used in drawing diagrams
const horizontal_padding: int = 32
const vertical_padding: int = 16
const max_square_size: int = 48
const line_width: int = 2
const extra_horizontal: float = 0.2

# Draw a visual representation of the Dyck path
# - Figure out the height and width
# - Determine the max size we can do for each part of the walk
# - Draw the lines and dots to make the path
func draw_contents_diagrams() -> void:
    print("Drawing house of cards with levels: ", levels)
    # Work out how much space we have to work with
    var available_space: Vector2 = size - Vector2(horizontal_padding * 2, vertical_padding * 2)
    
    # Work out the length and width of the squares if we want to fill this space
    var max_square_width: int = available_space.x / get_width()
    var max_square_height: int = available_space.y / (get_max_height())
    
    # We want to keep the squares square, but this can be changed to allow for rectangles
    var square_size: int = min(max_square_width, max_square_height)
    
    # Let's stop it from getting silly by restricting the maximum size (only affects small numbers)
    square_size = min(square_size, max_square_size)
    
    # Iterate through the levels and draw them
    # TODO: Test this
    for i: int in range(len(levels)):
        var level: Array = levels[i]
        
        # Draw the dots for this level
        for j: int in range(len(level)):
            if level[j] == 1:
                var x: int = horizontal_padding + j * square_size + (square_size / 2) * i
                var y: int = vertical_padding + available_space.y - (i+1) * square_size
                
                # Draw two diagonal lines representing the cards
                draw_line(Vector2(x, y + square_size), Vector2(x + square_size / 2, y), Color.BLACK, line_width)
                draw_line(Vector2(x + square_size, y + square_size), Vector2(x + square_size / 2, y), Color.BLACK, line_width)

                # Draw a horizontal line over the top connecting to any cards on the same level to the left
                if j > 0 and level[j - 1] == 1:
                    draw_line(Vector2(x + square_size / 2 + square_size * extra_horizontal, y), Vector2(x - square_size / 2 - square_size * extra_horizontal, y), Color.BLACK, line_width)
                
            
