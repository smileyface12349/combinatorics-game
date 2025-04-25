extends BijectionElement
class_name TableauxPairElement

var first: Array[Array]
var second: Array[Array]
# Each tableau is a list of lists, where each inner list is a row of the tableau
# For example, [[1, 2], [3]] represents a tableau with two rows: the first row has 1 and 2, and the second row has 3
# Must be increasing left to right and top to bottom. Also, the length of the lists must be non-increasing.

## parts: [number of 1s, number of 2s, number of 3s, ...]
## Constraint: Must not contain trailing zeroes
func _init(first: Array[Array], second: Array[Array], id: int) -> void:
    self.first = first
    self.second = second
    
    # Obtain a string representation
    var text: String = get_string_of_tableaux(first) + '|' + get_string_of_tableaux(second)
    super(text, id)

# Gets a string representation of a single tableaux (using ; and , as separators)
func get_string_of_tableaux(tableaux: Array[Array]) -> String:
    var outer_text_pieces: Array[String]
    for i: int in range(len(tableaux)):
        var inner_text_pieces: Array[String]
        for j: int in range(len(tableaux[i])):
            inner_text_pieces.append(str(tableaux[i][j]))
        outer_text_pieces.append(','.join(inner_text_pieces))
    return ';'.join(outer_text_pieces)

## Gets the width of both tableaux, with no space in between.
func get_width() -> int:
    return first[0].size() + second[0].size()
    
## Gets the height required to draw both tableaux.
func get_height() -> int:
    return max(first.size(), second.size())
    
func get_code_representation() -> Variant:
    return [first, second]

# Always draw diagrams, do not show text representation
func draw_contents_text() -> void:
    draw_contents_diagrams()

# Constants used in drawing Young diagrams
const horizontal_padding: int = 32
const vertical_padding: int = 16
const max_square_size: int = 32
const border_width: int = 2
const horizontal_separation: int = horizontal_padding

# Draw Young tableaux
# - Calculate how much vertical and horizontal space we need
# - Given how much space we've got, work out how big the cubes can be
# - Using the size of the cubes, get the position of each cube
# - Go over these cubes and draw them
func draw_contents_diagrams() -> void:
    # Work out how much space we have to work with
    var available_space: Vector2 = size - Vector2(horizontal_padding * 2, vertical_padding * 2)
    
    # Work out the length and width of the squares if we want to fill this space
    var max_square_width: int = (available_space.x - horizontal_separation) / (get_width())
    var max_square_height: int = available_space.y / get_height()
    
    # We want to keep the squares square, but this can be changed if we instead want to fill the space
    var square_size: int = min(max_square_width, max_square_height)
    
    # Let's stop it from getting silly by restricting the maximum size (only affects small numbers)
    square_size = min(square_size, max_square_size)

    # Draw the tableaux
    draw_tableau(horizontal_padding, first, square_size)
    draw_tableau(horizontal_padding + first[0].size() * square_size + horizontal_separation, second, square_size)

func draw_tableau(start_x: int, tableau: Array[Array], square_size: int) -> void:
    # Draw the first tableau
    var x: int = start_x
    var y: int = vertical_padding
    # y = vertical_padding + (get_height() - tableau.size()) * square_size / 2 # Center the tableaux vertically
    
    for i: int in range(len(tableau)):
        for j: int in range(len(tableau[i])):
            var number: int = tableau[i][j]
            draw_rect(Rect2(x, y, square_size, square_size), Color.BLACK, true) # Draw the outer box to represent the border
            draw_rect(Rect2(x + border_width, y + border_width, square_size - border_width * 2, square_size - border_width * 2), Color.WHITE, true) # Draw the inner box
            draw_string(font, Vector2(x + square_size / 2.0 - 6.0, y + square_size / 2.0 + 6.0), str(number), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color.BLACK) # Draw the number in the center of the box
            x += square_size
        x = start_x # Reset x for the next row
        y += square_size


